module Superstore
  module AttributeMethods
    extend ActiveSupport::Concern
    include ActiveModel::AttributeAssignment
    include ActiveModel::AttributeMethods
    include ActiveRecord::AttributeMethods::Read
    include ActiveRecord::AttributeMethods::Write

    included do
      # (Alias for the protected read_attribute method).
      def [](attr_name)
        read_attribute(attr_name)
      end

      # Updates the attribute identified by <tt>attr_name</tt> with the specified +value+.
      # (Alias for the protected write_attribute method).
      def []=(attr_name, value)
        write_attribute(attr_name, value)
      end
    end

    ###################################################
    # COPYPASTA BEGIN
    # From activerecord 5.1.6 ActiveRecord::AttributeMethods::ClassMethods
    ###################################################
    class GeneratedAttributeMethods < Module; end # :nodoc:

    module ClassMethods
      def inherited(child_class) #:nodoc:
        child_class.initialize_generated_modules
        super
      end

      def initialize_generated_modules # :nodoc:
        @generated_attribute_methods = GeneratedAttributeMethods.new { extend Mutex_m }
        @attribute_methods_generated = false
        include @generated_attribute_methods

        super
      end

      # Generates all the attribute related methods for columns in the database
      # accessors, mutators and query methods.
      def define_attribute_methods # :nodoc:
        return false if @attribute_methods_generated
        # Use a mutex; we don't want two threads simultaneously trying to define
        # attribute methods.
        generated_attribute_methods.synchronize do
          return false if @attribute_methods_generated
          superclass.define_attribute_methods unless self == base_class
          super(attribute_definitions.keys)
          @attribute_methods_generated = true
        end
        true
      end

      def undefine_attribute_methods # :nodoc:
        generated_attribute_methods.synchronize do
          super if defined?(@attribute_methods_generated) && @attribute_methods_generated
          @attribute_methods_generated = false
        end
      end

      def instance_method_already_implemented?(method_name)
        if dangerous_attribute_method?(method_name)
          raise DangerousAttributeError, "#{method_name} is defined by Active Record. Check to make sure that you don't have an attribute or method with the same name."
        end

        if superclass == Base
          super
        else
          # If ThisClass < ... < SomeSuperClass < ... < Base and SomeSuperClass
          # defines its own attribute method, then we don't want to overwrite that.
          defined = method_defined_within?(method_name, superclass, Base) &&
            ! superclass.instance_method(method_name).owner.is_a?(GeneratedAttributeMethods)
          defined || super
        end
      end

      # A method name is 'dangerous' if it is already (re)defined by Active Record, but
      # not by any ancestors. (So 'puts' is not dangerous but 'save' is.)
      def dangerous_attribute_method?(name) # :nodoc:
        method_defined_within?(name, Base)
      end

      def method_defined_within?(name, klass, superklass = klass.superclass) # :nodoc:
        if klass.method_defined?(name) || klass.private_method_defined?(name)
          if superklass.method_defined?(name) || superklass.private_method_defined?(name)
            klass.instance_method(name).owner != superklass.instance_method(name).owner
          else
            true
          end
        else
          false
        end
      end

      # A class method is 'dangerous' if it is already (re)defined by Active Record, but
      # not by any ancestors. (So 'puts' is not dangerous but 'new' is.)
      def dangerous_class_method?(method_name)
        BLACKLISTED_CLASS_METHODS.include?(method_name.to_s) || class_method_defined_within?(method_name, Base)
      end

      def class_method_defined_within?(name, klass, superklass = klass.superclass) # :nodoc:
        if klass.respond_to?(name, true)
          if superklass.respond_to?(name, true)
            klass.method(name).owner != superklass.method(name).owner
          else
            true
          end
        else
          false
        end
      end
      ###################################################
      # COPYPASTA END
      ###################################################


      def has_attribute?(attr_name)
        attribute_definitions.key?(attr_name.to_s)
      end
    end

    def write_attribute(name, value)
      @attributes[name.to_s] = self.class.typecast_attribute(name, value)
    end

    def read_attribute(name)
      name = name.to_s unless name.is_a?(String)

      if name == self.class.primary_key
        send(name)
      else
        @attributes[name]
      end
    end
    alias_method :_read_attribute, :read_attribute

    def attribute_present?(attribute)
      value = _read_attribute(attribute)
      !value.nil? && !(value.respond_to?(:empty?) && value.empty?)
    end

    def has_attribute?(name)
      @attributes.key?(name.to_s)
    end
    alias_method :attribute_exists?, :has_attribute?

    def attributes
      results = {}
      @attributes.each_key do |key|
        results[key] = read_attribute(key)
      end
      results
    end

    def attributes=(attributes)
      assign_attributes(attributes)
    end

    def method_missing(method_id, *args, &block)
      # self.class.define_attribute_methods unless self.class.attribute_methods_generated?

      if (match = matched_attribute_method(method_id.to_s))
        attribute_missing(match, *args, &block)
      else
        super
      end
    end

    protected
      def attribute_method?(name)
        !!attribute_definitions[name.to_s]
      end

    private
      def attribute(name)
        read_attribute(name)
      end

      def attribute=(name, value)
        write_attribute(name, value)
      end
  end
end
