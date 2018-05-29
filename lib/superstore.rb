require 'active_support/all'
require 'active_model'
require 'active_record'
require 'global_id/identification'

module Superstore
  extend ActiveSupport::Autoload

  autoload :AttributeMethods
  autoload :Base
  autoload :Associations
  autoload :Caching
  autoload :Connection
  autoload :Core
  autoload :Identity
  autoload :Inspect
  autoload :Model
  autoload :Persistence
  autoload :Schema
  autoload :Timestamps
  autoload :Type

  module AttributeMethods
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Definition
      autoload :Dirty
      autoload :PrimaryKey
      autoload :Typecasting
    end
  end

  module Adapters
    extend ActiveSupport::Autoload

    autoload :AbstractAdapter
    autoload :JsonbAdapter
  end

  module Associations
    extend ActiveSupport::Autoload

    autoload :Association
    autoload :AssociationScope
    autoload :Reflection
    autoload :BelongsTo
    autoload :HasMany
    autoload :HasOne

    module Builder
      extend ActiveSupport::Autoload

      autoload :Association
      autoload :BelongsTo
      autoload :HasMany
      autoload :HasOne
    end
  end

  module Relation
    extend ActiveSupport::Autoload

    autoload :Scrolling
  end

  module Types
    extend ActiveSupport::Autoload

    autoload :BaseType
    autoload :ArrayType
    autoload :BooleanType
    autoload :DateRangeType
    autoload :FloatType
    autoload :GeoPointType
    autoload :IntegerType
    autoload :IntegerRangeType
    autoload :JsonType
    autoload :RangeType
    autoload :StringType
    autoload :TimeType
  end
end

require 'superstore/railtie' if defined?(Rails)
