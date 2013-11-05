require 'json'

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
        const_name = entry[:key].to_s.upcase
        const_set(const_name, entry[:value])
        const_set("#{const_name}_LABEL", entry[:label])
        @entries << entry
      end

      def label_value_pairs
        labels.zip values
      end

      def get_label(value)
        get_from_entries(:label, value)
      end

      def get_key(value)
        get_from_entries(:key, value)
      end

      def attr_name; @attr_name end
      def keys;   mapped(:key) end
      def values; mapped(:value) end
      def labels; mapped(:label) end

      def to_h(options = {})
        default_to_include = [:key, :value, :label]

        [:only, :except].each do |key|
          if options.include?(key)
            if options[key].is_a?(Symbol)
              options[key] = [options[key]]
            elsif options[key].empty?
              options[key] = nil
            end

            unless options[key].nil? || (options[key] - default_to_include).empty?
              raise 'Unknown keys for enum'
            end
          end
        end

        to_include =
          if !options[:only].nil?
            default_to_include & options[:only]
          elsif !options[:except].nil?
            default_to_include - options[:except]
          else
            default_to_include
          end

        builder =
          if to_include.size == 1
            to_include = to_include.first
            proc { |entry| [entry.const_name, entry.send(to_include)]}
          else
            proc do |entry|
              value = Hash[entry.to_h.select { |(key, _)| to_include.include?(key) }]
              [entry.const_name, value]
            end
          end

        Hash[@entries.map(&builder)]
      end

      def to_json(options = {})
        to_h(options).to_json
      end

      private

      def get_from_entries(key, value)
        @entries.find { |hash| hash[:value] == value }.try(:[], key)
      end

      def mapped(key)
        @entries.map { |hash| hash[key] }
      end
    end
  end

end
