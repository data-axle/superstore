module CassandraObject
  class CounterBase
    class << self
      def base_class
        self
      end

      def config
        Base.config
      end

      def get(group, counter=nil)
        cql_string = "SELECT #{select_counter(counter)} FROM #{column_family} WHERE KEY = ?" # Multiple keys at once doesn't result right

        results = []
        attributes = execute_cql(cql_string, group).fetch_hash
        attributes.delete("KEY")
        results << attributes

        if !group.is_a?(Array) && results.size <= 1
          results = results.first
          if counter && !counter.is_a?(Array) && results.size <= 1
            results = results.values.first
          end
        end
        results
      end

      def update(group, counter, count=nil)
        execute_cql "UPDATE #{column_family} SET #{counter_updates(counter, count)} WHERE KEY = '#{group}'"
      end

      private

      def counter_updates(counter, count=nil)
        if !count.nil?
          counters = if counter.is_a?(Array); counter else [counter] end
          counters.map do |c| "'#{c}' = '#{c}' #{incr_decr(count)}" end.join ', '
        else
          counter.map do |c, count| "'#{c}' = '#{c}' #{incr_decr(count)}" end.join ', '
        end
      end

      def incr_decr(count)
        if count >= 0
          "+ #{count}"
        else
          "- #{count * -1}"
        end
      end

      def select_counter(counter)
        if counter.nil?
          "*"
        else
          counter.is_a?(Array) ? counter.map do |c| "'#{c}'" end.join(",") : "'#{counter}'"
        end
      end

    end

    extend ActiveModel::Naming
    include ActiveModel::Conversion
    extend ActiveSupport::DescendantsTracker

    include Connection
    include Consistency
    include Identity
    include Inspect
    extend  Model

  end
end
