module Superstore
  module AttributeAssignment
    def _assign_attribute(k, v)
      setter = :"#{k}="
      public_send(setter, v)
    rescue NoMethodError
      if respond_to?(setter)
        raise
      end
    end
  end
end
