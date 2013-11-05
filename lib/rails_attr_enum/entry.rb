require 'ostruct'

module RailsAttrEnum
  ## Enum entry class
  Entry = Struct.new(:const_name, :key, :value, :label) do
    # Add a to_h method if it doesn't exist (< ruby 2.0)
    unless nil.respond_to?(:to_h)
      def to_h
        Hash[members.map { |key| [key, send(key)] }]
      end
    end

    def to_json(*args)
      to_h.to_json
    end
  end
end
