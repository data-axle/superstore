module CassandraObject
  module Inspect
    def inspect
      inspection = ["#{self.class.primary_key}: #{id.inspect}"]

      @attributes.keys.each do |attribute|
        inspection << "#{attribute}: #{attribute_for_inspect(attribute)}"
      end

      "#<#{self.class} #{inspection * ', '}>"
    end

    def attribute_for_inspect(attr_name)
      value = read_attribute(attr_name)

      if value.is_a?(String) && value.length > 50
        "#{value[0..50]}...".inspect
      elsif value.is_a?(Date) || value.is_a?(Time)
        %("#{value.to_s(:db)}")
      else
        value.inspect
      end
    end
  end
end
