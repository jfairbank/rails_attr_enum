require 'spec_helper'

describe User do
  shared_examples 'it has the enum module' do
    it 'has the enum module' do
      expect(User::Role).to be_a(Module)
    end
  end

  shared_examples 'it sets default values' do
    it 'sets the default values' do
      expect(User::Role::ADMIN).to      eq(0)
      expect(User::Role::EDITOR).to     eq(1)
      expect(User::Role::AUTHOR).to     eq(2)
      expect(User::Role::SUBSCRIBER).to eq(3)
    end

    it 'sets the right value for an instance' do
      expect(admin.role).to  eq(0)
      expect(editor.role).to eq(1)
      expect(author.role).to eq(2)
      expect(user.role).to   eq(3)
    end
  end

  shared_examples 'it sets default labels' do
    it 'sets the default labels' do
      expect(User::Role::ADMIN_LABEL).to      eq('Admin')
      expect(User::Role::EDITOR_LABEL).to     eq('Editor')
      expect(User::Role::AUTHOR_LABEL).to     eq('Author')
      expect(User::Role::SUBSCRIBER_LABEL).to eq('Subscriber')
    end
  end

  shared_examples 'it sets the appropriate values' do |admin_value, editor_value, author_value, user_value|
    it 'sets the appropriate values' do
      expect(User::Role::ADMIN).to      eq(admin_value)
      expect(User::Role::EDITOR).to     eq(editor_value)
      expect(User::Role::AUTHOR).to     eq(author_value)
      expect(User::Role::SUBSCRIBER).to eq(user_value)
    end

    it 'sets the right value for an instance' do
      expect(admin.role).to  eq(admin_value)
      expect(author.role).to eq(author_value)
      expect(editor.role).to eq(editor_value)
      expect(user.role).to   eq(user_value)
    end
  end

  let(:admin)  { User.new(role: :admin) }
  let(:editor) { User.new(role: :editor) }
  let(:author) { User.new(role: :author) }
  let(:user)   { User.new(role: :subscriber) }

  #context 'when passing all symbols' do
    #before :each do
      #default_user_roles
    #end

    #it_behaves_like 'it has the enum module'
    #it_behaves_like 'it sets default values'
    #it_behaves_like 'it sets default labels'
  #end

  context 'when passing an array' do
    before :each do
      clear_user

      User.class_eval do
        extend RailsAttrEnum
        attr_enum :role, [:admin, :editor, :author, :subscriber]
      end
    end
  end

  context 'when specifying values' do
    context 'with a mix of symbols and hashes and a symbol is first' do
      before :each do
        clear_user

        User.class_eval do
          extend RailsAttrEnum
          attr_enum :role, [:admin, { editor: 12 }, :author, { subscriber: 42 }]
        end
      end

      it_behaves_like 'it has the enum module'
      it_behaves_like 'it sets the appropriate values', 0, 12, 1, 42
      it_behaves_like 'it sets default labels'
    end

    context 'with a hash' do
      before :each do
        clear_user

        User.class_eval do
          extend RailsAttrEnum
          attr_enum :role, { admin: 1, editor: 2, author: 4, subscriber: 8 }
        end
      end

      it_behaves_like 'it has the enum module'
      it_behaves_like 'it sets the appropriate values', 1, 2, 4, 8
      it_behaves_like 'it sets default labels'
    end
  end
end
