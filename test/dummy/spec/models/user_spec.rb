require 'spec_helper'

describe User do
  shared_examples 'it has the enum module' do
    it 'has the enum module' do
      expect(User::Role).to be_a Module
    end
  end

  shared_examples 'it sets default values' do
    it 'sets the default values' do
      expect(User::Role::ADMIN).to eq(0)
      expect(User::Role::AUTHOR).to eq(1)
      expect(User::Role::EDITOR).to eq(2)
      expect(User::Role::USER).to eq(3)
    end

    it 'sets the right value for an instance' do
      expect(u_admin.role).to eq(0)
      expect(u_author.role).to eq(1)
      expect(u_editor.role).to eq(2)
      expect(u_user.role).to eq(3)
    end
  end

  shared_examples 'it sets default labels' do
    it 'sets the default labels' do
      expect(User::Role::ADMIN_LABEL).to eq('Admin')
      expect(User::Role::AUTHOR_LABEL).to eq('Author')
      expect(User::Role::EDITOR_LABEL).to eq('Editor')
      expect(User::Role::USER_LABEL).to eq('User')
    end
  end

  shared_examples 'it sets the appropriate values' do |admin_value, author_value, editor_value, user_value|
    it 'sets the appropriate values' do
      expect(User::Role::ADMIN).to eq(admin_value)
      expect(User::Role::AUTHOR).to eq(author_value)
      expect(User::Role::EDITOR).to eq(editor_value)
      expect(User::Role::USER).to eq(user_value)
    end

    it 'sets the right value for an instance' do
      expect(u_admin.role).to eq(admin_value)
      expect(u_author.role).to eq(author_value)
      expect(u_editor.role).to eq(editor_value)
      expect(u_user.role).to eq(user_value)
    end
  end

  let(:u_admin)  { User.new(role: User::Role::ADMIN) }
  let(:u_author) { User.new(role: User::Role::AUTHOR) }
  let(:u_editor) { User.new(role: User::Role::EDITOR) }
  let(:u_user)   { User.new(role: User::Role::USER) }

  def clear_user
    if User.const_defined?(:Role)
      User.send(:remove_const, :Role)
    end

    if User.instance_variable_defined?(:@_attr_enums)
      User.remove_instance_variable(:@_attr_enums)
    end
  end

  context 'when passing all symbols' do
    before :each do
      clear_user

      User.class_eval do
        extend RailsAttrEnum
        attr_enum :role, :admin, :author, :editor, :user
      end
    end

    it_behaves_like 'it has the enum module'
    it_behaves_like 'it sets default values'
    it_behaves_like 'it sets default labels'
  end

  context 'when specifying values' do
    context 'with a mix of symbols and hashes and a symbol is first' do
      before :each do
        clear_user

        User.class_eval do
          extend RailsAttrEnum
          attr_enum :role, :admin, { author: 12 }, :editor, { user: 42 }
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
          attr_enum :role, admin: 1, author: 2, editor: 4, user: 8
        end
      end

      it_behaves_like 'it has the enum module'
      it_behaves_like 'it sets the appropriate values', 1, 2, 4, 8
      it_behaves_like 'it sets default labels'
    end
  end
end
