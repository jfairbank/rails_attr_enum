module RailsAttrEnum
  def attr_enum(attribute, members = nil, &block)
    builder = EnumBuilder.new(self, attribute)

    if block.nil?
      builder.build_from_enumerable(members)
    else
      builder.build_from_block(block)
    end
  end

  autoload :Enum,             'rails_attr_enum/enum'
  autoload :EnumBlockBuilder, 'rails_attr_enum/enum_block_builder'
  autoload :EnumBuilder,      'rails_attr_enum/enum_builder'
  autoload :Member,           'rails_attr_enum/member'
  autoload :Version,          'rails_attr_enum/version'
end
