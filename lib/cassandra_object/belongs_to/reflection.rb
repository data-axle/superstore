module CassandraObject
  module BelongsTo
    class Reflection
      attr_reader :model, :name, :options
      def initialize(model, name, options)
        @model, @name, @options = model, name, options
      end

      def instance_variable_name
        "@#{name}"
      end

      def foreign_key
        "#{name}_id"
      end

      def polymorphic_column
        "#{name}_type"
      end

      def polymorphic?
        options[:polymorphic]
      end

      def class_name
        options[:class_name] || name.to_s.classify 
      end
    end
  end
end