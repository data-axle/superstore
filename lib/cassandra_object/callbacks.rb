module CassandraObject
  module Callbacks
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Callbacks
      include ActiveModel::Validations::Callbacks

      define_model_callbacks :save, :create, :update, :destroy
    end

    def destroy #:nodoc:
      run_callbacks(:destroy) { super }
    end

    private
      def write(*args) #:nodoc:
        run_callbacks(:save) { super }
      end

      def create #:nodoc:
        run_callbacks(:create) { super }
      end

      def update(*) #:nodoc:
        run_callbacks(:update) { super }
      end
  end
end
