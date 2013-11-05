require 'spec_helper'

describe User do
  before :all do
    # Create test users
    create(:user, :role_admin)
    2.times { create(:user, :role_editor) }
    5.times { create(:user, :role_author) }
    20.times { create(:user, :role_user) }
  end

  before { default_user_roles }

  it 'adds the scope methods for each possible enum value' do
    scopes = [:role_admin, :role_editor, :role_admin, :role_user]
    expect(User).to respond_to(*scopes)
  end

  it 'returns the correct count from the db' do
    expect(User.role_admin.count).to  eq(1)
    expect(User.role_editor.count).to eq(2)
    expect(User.role_author.count).to eq(5)
    expect(User.role_user.count).to   eq(20)
  end
end
