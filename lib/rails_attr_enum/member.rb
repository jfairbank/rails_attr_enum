require 'ostruct'

module RailsAttrEnum
  Member = Struct.new(:key, :value, :label) do
    def serialized_value(options = {})
      fields = self.members.dup

      if (only = options[:only])
        fields &= Array(only)
      elsif (except = options[:except])
        fields -= Array(except)
      end

      if fields.size == 1
        send(fields.first)
      else
        fields.each_with_object({}) do |field, hash|
          hash[field] = send(field)
        end
      end
    end
  end
end
