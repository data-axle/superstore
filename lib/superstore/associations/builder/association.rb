module Superstore::Associations::Builder
  class Association
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

      reflection = Superstore::Associations::Reflection.new(model, name, options)
      model.association_reflections = model.association_reflections.merge(name => reflection)
    end

    def mixin
      model.generated_association_methods
    end

    def define_writer
      name = self.name
      mixin.redefine_method("#{name}=") do |records|
        association(name).writer(records)
      end
    end

    def define_reader
      name = self.name
      mixin.redefine_method(name) do
        association(name).reader
      end
    end
  end
end