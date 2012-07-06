module CassandraObject
  module Callbacks
    extend ActiveSupport::Concern

    included do
      extend ActiveModel::Callbacks
      include ActiveModel::Validations::Callbacks

      define_model_callbacks :save, :create, :update, :destroy
    end

    def destroy #:nodoc:
      _run_destroy_callbacks { super }
    end

    private
      def write #:nodoc:
        _run_save_callbacks { super }
      end

      def create #:nodoc:
        _run_create_callbacks { super }
      end

      def update(*) #:nodoc:
        _run_update_callbacks { super }
      end
  end
end
