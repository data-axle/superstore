module Superstore
  module AttributeAssignment
    def _assign_attribute(k, v)
      public_send("#{k}=", v) if respond_to?("#{k}=")
    end
  end
end
