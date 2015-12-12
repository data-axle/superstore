module Superstore
  module Types
    class JsonType < BaseType
      OJ_OPTIONS = {mode: :compat}
      def typecast(data)
        Oj.load Oj.dump(data, OJ_OPTIONS)
      end
    end
  end
end
