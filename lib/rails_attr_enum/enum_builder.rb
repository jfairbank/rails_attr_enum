require 'set'

module RailsAttrEnum
  class EnumBuilder
    def initialize(klass, attribute)
      @klass, @attribute    = klass, attribute
      @attribute_const_name = attribute.to_s.camelize

      check_enum_exists!
      set_up_enum!
    end

    def build_from_enumerable(keys)
      keys.each do |key, data|
        member = if data.nil?
          if key.respond_to?(:first)
            member_from_key_and_data(*key.first)
          else
            member_from_key(key)
          end
        else
          member_from_key_and_data(key, data)
        end

        set_up_enum_with_member(member)
      end

      add_methods
      add_validations
    end

    def build_from_block(block)
      block_builder = EnumBlockBuilder.new(self)
      block_builder.instance_eval(&block)

      add_methods
      add_validations
    end

    private

    def check_enum_exists!
      if @klass.const_defined?(@attribute_const_name)
        raise "Already defined enum for '#{@attribute}'"
      end
    end

    def set_up_enum!
      if @klass.table_exists? && !@klass.column_names.include?(@attribute.to_s)
        puts "Warning: Cannot create enum for '#{@attribute}' because that attribute does not exist for '#{@klass.name}'"
        return
      end

      @enum   = Module.new.tap { |enum| enum.include Enum }
      @values = SortedSet.new
      @klass.const_set(@attribute_const_name, @enum)
    end

    def add_validations
      @klass.validates(@attribute, inclusion: { in: @enum.values }, allow_nil: true)
    end

    def member_from_key(key)
      Member.new(key, next_free_value!, default_label(key))
    end

    def member_from_key_and_data(key, data)
      case data
      when Fixnum
        label = default_label(key)
        value = use_value!(data)
      when String
        label = data
        value = next_free_value!
      else
        label = data[:label] || default_label(key)
        value = data[:value].nil? ? next_free_value! : use_value!(data[:value])
      end

      Member.new(key, value, label)
    end

    def set_up_enum_with_member(member)
      const_name = member.key.to_s.upcase
      @enum.const_set(const_name, member.value)
      @enum.const_set("#{const_name}_LABEL", member.label)
      @enum.instance_variable_get(:@_enum_members)[member.key] = member
    end

    def add_methods
      @klass.class_eval <<-EOS, __FILE__, __LINE__ + 1
        scope :#{@attribute}, ->(key) { where(#{@attribute}: #{@attribute_const_name}[key]) }

        # Add the display method like 'display_status' for attribute 'status'
        def display_#{@attribute}
          return '' if #{@attribute}.blank?
          self.class::#{@attribute_const_name}.get_label(#{@attribute})
        end

        # Get the key of the value
        def #{@attribute}_key
          self.class::#{@attribute_const_name}.get_key(#{@attribute})
        end

        # Add method like 'status?' for @attribute 'status' (overwrites rails method)
        #def #{@attribute}_with_value_check?(key = nil)
        def #{@attribute}?(key = nil)
          if key.nil?
            ##{@attribute}_without_value_check?
            !#{@attribute}.nil?
          else
            #{@attribute} == self.class::#{@attribute_const_name}[key]
          end
        end
        #alias_method_chain :#{@attribute}?, :with_value_check

        # Override the `attr=` method
        def #{@attribute}=(key)
          if key.is_a?(Symbol)
            value = self.class::#{@attribute_const_name}[key]
            write_attribute(:#{@attribute}, value)
            value
          else
            super(key)
          end
        end
      EOS
    end

    def default_label(attribute)
      attribute.to_s.titleize
    end

    def use_value!(value)
      if @values.member?(value)
        raise "Already used value #{value}"
      end

      @values << value
      value
    end

    def next_free_value!
      counter = 0

      value =
        if @values.empty?
          0
        else
          @values.each do |value|
            next if value < 0
            break if value != counter
            counter += 1
          end
          counter
        end

      use_value!(value)
    end
  end
end
