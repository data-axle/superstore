module CassandraObject
  module IntegerType
    REGEX = /\A[-+]?\d+\Z/
    def encode(int)
      return '' if int.nil?
      int = int.to_i if int.kind_of?(String) && int.match(REGEX)
      raise ArgumentError.new("#{self} requires an Integer. You passed #{int.inspect}") unless int.kind_of?(Integer)
      int.to_s
    end
    module_function :encode

    def decode(str)
      return nil if str.empty?
      raise ArgumentError.new("#{str} isn't a String that looks like a Integer") unless str.kind_of?(String) && str.match(REGEX)
      str.to_i
    end
    module_function :decode
  end

  module FloatType
    REGEX = /\A[-+]?\d+(\.\d+)\Z/
    def encode(float)
      return '' if float.nil?
      float = float.to_f if float.kind_of?(String) && float.match(REGEX)
      raise ArgumentError.new("#{self} requires a Float") unless float.kind_of?(Float)
      float.to_s
    end
    module_function :encode

    def decode(str)
      return nil if str.empty?
      raise ArgumentError.new("#{str} isn't a String that looks like a Float") unless str.kind_of?(String) && str.match(REGEX)
      str.to_f
    end
    module_function :decode
  end
  
  module DateType
    FORMAT = '%Y-%m-%d'
    REGEX = /\A\d{4}-\d{2}-\d{2}\Z/
    def encode(date)
      return '' if date.nil?
      date = Date.parse(date) if date.kind_of?(String) && date.match(REGEX)
      raise ArgumentError.new("#{self} requires a Date") unless date.kind_of?(Date)
      date.strftime(FORMAT)
    end
    module_function :encode

    def decode(str)
      return nil if str.empty?
      raise ArgumentError.new("#{str} isn't a String that looks like a Date") unless str.kind_of?(String) && str.match(REGEX)
      Date.strptime(str, FORMAT)
    end
    module_function :decode
  end

  module TimeType
    # lifted from the implementation of Time.xmlschema and simplified
    REGEX = /\A\s*
              (-?\d+)-(\d\d)-(\d\d)
              T
              (\d\d):(\d\d):(\d\d)
              (\.\d*)?
              (Z|[+-]\d\d:\d\d)?
              \s*\z/ix

    def encode(time)
      return '' if time.nil?
      time = Time.parse(time) if time.kind_of?(String) && time.match(REGEX)
      raise ArgumentError.new("#{self} requires a Time") unless time.kind_of?(Time)
      time.xmlschema(6)
    end
    module_function :encode

    def decode(str)
      return nil if str.empty?
      raise ArgumentError.new("#{str} isn't a String that looks like a Time") unless str.kind_of?(String) && str.match(REGEX)
      Time.xmlschema(str)
    end
    module_function :decode
  end
  
  module TimeWithZoneType
    def encode(time)
      return '' if time.nil?
      time = Time.zone.parse(time) if time.kind_of?(String) && time.match(TimeType::REGEX)
      raise ArgumentError.new("#{self} requires a Time") unless time.kind_of?(Time)
      time.utc.xmlschema(6)
    end
    module_function :encode

    def decode(str)
      return nil if str.empty?
      raise ArgumentError.new("#{str} isn't a String that looks like a Time") unless str.kind_of?(String) && str.match(TimeType::REGEX)
      Time.xmlschema(str).in_time_zone
    end
    module_function :decode
  end

  module StringType
    def encode(str)
      return '' if str.nil?
      raise ArgumentError.new("#{self} requires a String") unless str.kind_of?(String)
      str.dup
    end
    module_function :encode

    def decode(str)
      str
    end
    module_function :decode
  end
  
  module UTF8StringType
    def encode(str)
      return '' if str.nil?
      # This is technically the most correct, but it is a pain to require utf-8 encoding for all strings. Should revisit.
      #raise ArgumentError.new("#{self} requires a UTF-8 encoded String") unless str.kind_of?(String) && str.encoding == Encoding::UTF_8
      raise ArgumentError.new("#{self} requires a String") unless str.kind_of?(String)
      str.dup
    end
    module_function :encode

    def decode(str)
      str.force_encoding('UTF-8')
    end
    module_function :decode
  end

  module HashType
    def encode(hash)
      return '' if hash.nil?
      raise ArgumentError.new("#{self} requires a Hash") unless hash.kind_of?(Hash)
      ActiveSupport::JSON.encode(hash)
    end
    module_function :encode

    def decode(str)
      return nil if str.empty?
      ActiveSupport::JSON.decode(str)
    end
    module_function :decode
  end

  module BooleanType
    TRUE_VALS = [true, 'true', '1']
    FALSE_VALS = [false, 'false', '0', nil]
    def encode(bool)
      unless TRUE_VALS.any? { |a| bool == a } || FALSE_VALS.any?{ |a| bool == a }
        raise ArgumentError.new("#{self} requires a Boolean or nil")
      end
      TRUE_VALS.include?(bool) ? '1' : '0'
    end
    module_function :encode

    def decode(bool)
      bool == '1'
    end
    module_function :decode
  end
end
