module Superstore
  module Core
    extend ActiveSupport::Concern

    def inspect
      inspection = []
      inspection << "#{self.class.primary_key}: #{id.inspect}" if self.class.has_primary_key?

      (self.class.attribute_names - [self.class.primary_key]).each do |name|
        value = send(name)

        if value.present? || value === false
          inspection << "#{name}: #{attribute_for_inspect(name)}"
        end
      end

      "#<#{self.class} #{inspection * ', '}>"
    end
  end
end
