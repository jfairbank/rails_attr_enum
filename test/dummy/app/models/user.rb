class User < ActiveRecord::Base
  extend RailsAttrEnum

  attr_enum :role, :admin, :editor, :author, :user
end
