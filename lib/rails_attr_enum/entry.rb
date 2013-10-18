require 'ostruct'

module RailsAttrEnum
  ## Enum entry class
  Entry = Struct.new(:key, :value, :label)
end
