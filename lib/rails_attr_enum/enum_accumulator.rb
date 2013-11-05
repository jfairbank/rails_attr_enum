require 'set'

module RailsAttrEnum

  ## Class to build up enum values
  class EnumAccumulator
    attr_reader :entries, :validation_rules

    def initialize
      @entries = []
      @validation_rules = {}
      @values = SortedSet.new
    end

    def add(key)
      if key.is_a?(Hash)
        key, value = key.first

        case value
        when String
          label = value
          value = next_free_value
        when Hash
          label = value[:label] || key.to_s.titleize
          value = value[:value] || next_free_value
        when Numeric
          label = key.to_s.titleize
        end
      else
        value = next_free_value
        label = key.to_s.titleize
      end

      const_name = key.to_s.upcase

      add_entry(const_name, key, value, label)
    end

    def validates(rules = {})
      @validation_rules = rules
    end

    private

    def add_entry(const_name, key, value, label)
      Entry.new(const_name, key, value, label).tap do |entry|
        revalue_entries!(value)
        @entries << entry
        @values << value
      end
    end

    def revalue_entries!(value)
      @entries.each do |entry|
        if entry.value == value
          entry.value = next_free_value!
        end
      end
    end

    def next_free_value
      counter = 0
      value =
        if @values.empty?
          0
        else
          @values.each do |v|
            next if v < 0
            break if v != counter
            counter += 1
          end
          counter
        end

      value
    end

    def next_free_value!
      next_free_value.tap { |v| @values << v }
    end
  end

end
