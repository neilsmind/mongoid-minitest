module Mongoid
  module Matchers
    # TODO: Add documentation.
    def have_index_for *attrs
      HaveIndexMatcher.new(*attrs)
    end

    private

    class HaveIndexMatcher < Matcher
      attr_reader :attrs, :klass

      def initialize *attrs
        @attrs = attrs.map(&:to_sym)
      end

      def matches? subject
        @klass = class_of subject
        klass.index_options.any? { |idx, _| idx.keys == attrs }
      end

      def failure_message
        "#{klass} to #{description}, but only found indexes #{indexes.inspect}"
      end

      def negative_failure_message
        "#{klass} to not #{description}, but found an index for #{attrs.inspect}"
      end

      def description
        "have an index for #{attrs.inspect}"
      end

      private

      def indexes
        klass.index_options.keys.map(&:keys)
      end
    end
  end
end
