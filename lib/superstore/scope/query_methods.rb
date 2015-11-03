module Superstore
  module QueryMethods
    def select!(*values)
      self.select_values += values.flatten
      self
    end

    def select(*values, &block)
      if block_given?
        to_a.select(&block)
      else
        clone.select! *values
      end
    end

    def where!(*values)
      self.where_values += values.flatten
      self
    end

    def where(*values)
      clone.where! values
    end

    def where_ids!(*ids)
      self.id_values += ids.flatten
      self
    end

    def where_ids(*ids)
      clone.where_ids! ids
    end

    def limit!(value)
      self.limit_value = value
      self
    end

    def limit(value)
      clone.limit! value
    end

    def order!(*values)
      self.order_values = values.flatten
      self
    end

    def order(*values)
      clone.order! values
    end
  end
end
