require 'ostruct'

module RailsAttrEnum
  ## Forwarding class for actual attribute value
  EntryValue = Struct.new(:model, :attr_name, :enum) do
    delegate :==, :===, :inspect, to: :value

    def method_missing(name, *args, &block)
      default = proc { value.send(name, *args, &block) }

      if matches = /^(.*?)((\?|!)?)$/.match(name)
        const_name = matches[1].to_s.upcase
        if enum.const_defined?(const_name)
          case matches[2]
          when '?'
            value == enum.const_get(const_name)
          when '!'
            self.value = enum.const_get(const_name)
          else
            enum.const_get(const_name)
          end
        else
          default.call
        end
      else
        default.call
      end
    end

    def key
      enum.get_key(value)
    end

    def value
      model.read_attribute(attr_name)
    end

    private

    def value=(v)
      model.send(:write_attribute, attr_name, v)
    end
  end
end
