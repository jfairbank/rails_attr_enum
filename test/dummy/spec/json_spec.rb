require 'spec_helper'
require 'json'

describe 'User#to_json' do
  before :each do
    clear_user

    User.class_eval do
      extend RailsAttrEnum
      attr_enum :role, :admin, :author, :editor, :user
    end
  end

  it 'correctly generates the json for the enum attribute' do
    user = User.new(role: User::Role::AUTHOR)
    user_json = user.to_json(only: :role)

    expect(user_json).to eq({ role: 1 }.to_json)
  end
end
