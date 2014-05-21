module RailsAttrEnum
  class EnumBlockBuilder
    def initialize(builder)
      @builder = builder
    end

    private

    def member(key, options = {})
      @builder.add_member(key => options)
    end
  end
end
