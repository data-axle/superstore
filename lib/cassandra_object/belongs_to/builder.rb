module CassandraObject
  module BelongsTo
    class Builder
      def self.build(model, name, options)
        new(model, name, options).build
      end

      attr_reader :model, :name, :options
      def initialize(model, name, options)
        @model, @name, @options = model, name, options
      end

      def build
        define_writer
        define_reader

        reflection = CassandraObject::BelongsTo::Reflection.new(model, name, options)
        model.belongs_to_reflections = model.belongs_to_reflections.merge(name => reflection)
      end

      def mixin
        model.generated_belongs_to_methods
      end

      def define_writer
        name = self.name
        mixin.redefine_method("#{name}=") do |records|
          belongs_to_association(name).writer(records)
        end
      end

      def define_reader
        name = self.name
        mixin.redefine_method(name) do
          belongs_to_association(name).reader
        end
      end
    end
  end
end
