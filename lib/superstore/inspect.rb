module Superstore
  module Inspect
    def inspect
      inspection = ["#{self.class.primary_key}: #{id.inspect}"]

      (self.class.attribute_names - [self.class.primary_key]).each do |name|
        value = send(name)

        if value.present? || value === false
          inspection << "#{name}: #{attribute_for_inspect(value)}"
        end
      end

      "#<#{self.class} #{inspection * ', '}>"
    end
  end
end
