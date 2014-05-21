require 'spec_helper'

describe 'Role enum for User' do
  before :each do
    # Ensure default enum set up
    default_user_roles

    # Create test users
    # Having issues with FactoryGirl and changing the role enum values
    # between tests
    # create(:user, :role_admin)
    # 2.times { create(:user, :role_editor) }
    # 5.times { create(:user, :role_author) }
    # 20.times { create(:user, :role_user) }

               User.create(role: User::Role::ADMIN)
    2.times  { User.create(role: User::Role::EDITOR) }
    5.times  { User.create(role: User::Role::AUTHOR) }
    20.times { User.create(role: User::Role::SUBSCRIBER)   }
  end

  it 'adds the scope methods for each possible enum value' do
    expect(User).to respond_to(:role)
  end

  it 'returns the correct count from the db' do
    expect(User.role(:admin)).to      have(1).items
    expect(User.role(:editor)).to     have(2).items
    expect(User.role(:author)).to     have(5).items
    expect(User.role(:subscriber)).to have(20).items
  end
end
