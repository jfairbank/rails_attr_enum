module RailsAttrEnum

  autoload :Attr,            'rails_attr_enum/attr.rb'
  autoload :Entry,           'rails_attr_enum/entry.rb'
  autoload :EntryValue,      'rails_attr_enum/entry_value.rb'
  autoload :Enum,            'rails_attr_enum/enum.rb'
  autoload :EnumAccumulator, 'rails_attr_enum/enum_accumulator.rb'
  autoload :Version,         'rails_attr_enum/version.rb'

  def attr_enum(attr_name, *keys, &block)
    if block_given?
      add_attr_enum_through_block(attr_name, &block)
    else
      if keys.first.is_a?(Hash) && keys.first.size > 1
        add_attr_enum_through_block(attr_name) do
          keys.first.each { |k, v| add k => v }
        end
      else
        add_attr_enum_through_block(attr_name) do
          keys.each { |k| add k }
        end
      end
    end

    nil
  end

  private

  def add_attr_enum(attr_name, entries, validation_rules)
    attr = Attr.new(attr_name)

    @_attr_enums ||= {}

    if table_exists? && !column_names.include?(attr.name)
      puts "Warning: Cannot create enum for '#{attr.name}' because that attribute does not exist for '#{self.name}'"
      return
    end

    if @_attr_enums.any? { |(_, enm)| enm.attr_name == attr.name }
      raise "Already defined enum for '#{attr.name}'"
    end

    @_attr_enums[attr.name.to_sym] = Module.new { include Enum }.tap do |mod|
      mod.init_enum(attr.name)
      const_set(attr.enum_name, mod)

      entries.each do |entry|
        mod.add(entry)
        class_eval <<-EOS
          scope :#{attr.name}_#{entry.key}, -> { where(:#{attr.name} => #{entry.value}) }
        EOS
      end

      validates(attr.name.to_sym, validation_rules.merge(inclusion: { in: mod.values }))
    end

    add_methods(attr)
  end

  def add_attr_enum_through_block(attr_name, &block)
    acc = EnumAccumulator.new
    acc.instance_eval(&block)
    add_attr_enum(attr_name, acc.entries, acc.validation_rules)
  end

  # def add_attr_display_method(attr)
  def add_methods(attr)
    class_eval <<-EOS, __FILE__, __LINE__ + 1
      # Add the display method like 'display_status' for attribute 'status'
      def display_#{attr.name}
        value = read_attribute(:#{attr.name})
        return '' if value.nil?
        self.class.instance_variable_get(:@_attr_enums)[:#{attr.name}].get_label(value)
      end

      # Add method like 'status?' for attribute 'status'
      def #{attr.name}?(key = nil)
        if key.nil?
          !read_attribute(:#{attr.name}).nil?
        else
          read_attribute(:#{attr.name}) == #{attr.enum_name}.const_get(key.to_s.upcase)
        end
      end

      # Override the attr= method
      def #{attr.name}=(key)
        if key.is_a? Symbol
          #{attr.enum_name}.const_get(key.to_s.upcase).tap do |value|
            write_attribute(:#{attr.name}, value)
          end
        else
          super
        end
      end

      # Override the attr method
      def #{attr.name}
        EntryValue.new(self, :#{attr.name}, #{attr.enum_name})
      end
    EOS
  end

end
