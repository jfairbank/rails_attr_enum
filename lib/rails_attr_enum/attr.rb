module RailsAttrEnum
  ## Represent an attribute
  class Attr
    attr_reader :name, :enum_name

    def initialize(name)
      @name = name.to_s
      @enum_name = @name.camelize
    end
  end
end
