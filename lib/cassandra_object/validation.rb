module CassandraObject
  class RecordInvalid < StandardError
    attr_reader :record
    def initialize(record)
      @record = record
      super("Invalid record: #{@record.errors.full_messages.to_sentence}")
    end
    
    def self.raise_error(record)
      raise new(record)
    end
  end

  module Validation
    extend ActiveSupport::Concern
    include ActiveModel::Validations
    
    included do
      define_model_callbacks :validation
      define_callbacks :validate, :scope => :name
    end
    
    module ClassMethods
      def create!(attributes)
        new(attributes).tap &:save!
      end
    end
    
    module InstanceMethods
      def valid?
        run_callbacks :validation do
          super
        end
      end

      def save
        if valid?
          super
        else
          false
        end
      end
      
      def save!
        save || RecordInvalid.raise_error(self)
      end
      
    end
  end
end
