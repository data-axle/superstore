module Superstore
  module Associations
    class Reflection
      attr_reader :macro, :name, :model, :options
      def initialize(macro, name, model, options)
        @macro  = macro
        @name   = name
        @model  = model
        @options = options
      end

      def association_class
        case macro
        when :has_many
          Superstore::Associations::HasMany
        when :belongs_to
          Superstore::Associations::BelongsTo
        end
        
      end

      def instance_variable_name
        "@#{name}"
      end

      def foreign_key
        @foreign_key ||= options[:foreign_key] || derive_foreign_key
      end

      def primary_key
        options[:primary_key] || "id"
      end

      def default_primary_key?
        primary_key == "id"
      end

      def polymorphic_column
        "#{name}_type"
      end

      def polymorphic?
        options[:polymorphic]
      end

      def class_name
        @class_name ||= (options[:class_name] || name.to_s.classify)
      end

      private
      
      def derive_foreign_key
        case macro
        when :has_many
          model.name.foreign_key
        when :belongs_to
          "#{name}_id"
        end
      end

    end
  end
end
