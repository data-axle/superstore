module Superstore
  module AttributeMethods
    extend ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    included do
      attribute_method_suffix("=")

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

    module ClassMethods
      def inherited(child_class)
        child_class.define_attribute_methods
        super
      end

      def define_attribute_methods
        return if attribute_methods_generated?
        super(attribute_definitions.keys)
        @attribute_methods_generated = true
      end

      def attribute_methods_generated?
        @attribute_methods_generated ||= false
      end
    end

    def write_attribute(name, value)
      @attributes[name.to_s] = self.class.typecast_attribute(name, value)
    end

    def read_attribute(name)
      @attributes[name.to_s]
    end

    def attribute_exists?(name)
      @attributes.key?(name.to_s)
    end

    def attributes
      results = {}
      @attributes.each_key do |key|
        results[key] = read_attribute(key)
      end
      results
    end

    def attributes=(attributes)
      attributes.each do |(name, value)|
        send("#{name}=", value)
      end
    end

    def method_missing(method_id, *args, &block)
      if !self.class.attribute_methods_generated?
        self.class.define_attribute_methods
        send(method_id, *args, &block)
      else
        super
        # match = match_attribute_method?(method_id.to_s)
        # match ? attribute_missing(match, *args, &block) : super
      end
    end

    def respond_to?(*args)
      self.class.define_attribute_methods unless self.class.attribute_methods_generated?
      super
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
