module RailsAttrEnum

  ## Enum representation
  module Enum
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def init_enum(attr_name)
        return if @init
        @attr_name = attr_name
        @entries = []
        @init = true
      end

      def add(entry)
        const_set(entry[:key], entry[:value])
        const_set("#{entry[:key]}_LABEL", entry[:label])
        @entries << entry
      end

      def label_value_pairs
        labels.zip values
      end

      def get_label(value)
        @entries.find { |hash| hash[:value] == value }.try(:[], :label)
      end

      def attr_name; @attr_name end
      def keys;   mapped(:key) end
      def values; mapped(:value) end
      def labels; mapped(:label) end

      private

      def mapped(key)
        @entries.map { |hash| hash[key] }
      end
    end
  end

end
