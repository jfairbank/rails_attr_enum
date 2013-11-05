require 'spec_helper'

describe 'User::Role.to_h' do
  let(:enum) { User::Role }

  before { default_user_roles }

  let :only_value do
    {
      'ADMIN'  => 0,
      'EDITOR' => 1,
      'AUTHOR' => 2,
      'USER'   => 3
    }
  end

  let :value_and_label do
    {
      'ADMIN'  => { value: 0, label: 'Admin' },
      'EDITOR' => { value: 1, label: 'Editor' },
      'AUTHOR' => { value: 2, label: 'Author' },
      'USER'   => { value: 3, label: 'User' }
    }
  end

  let :all_keys do
    {
      'ADMIN'  => { key: :admin,  label: 'Admin',  value: 0 },
      'EDITOR' => { key: :editor, label: 'Editor', value: 1 },
      'AUTHOR' => { key: :author, label: 'Author', value: 2 },
      'USER'   => { key: :user,   label: 'User',   value: 3}
    }
  end

  context 'without options' do
    subject { enum.to_h }
    it { should eq all_keys }
  end

  context 'with option `only` as a symbol' do
    subject { enum.to_h(only: :value) }
    it { should eq only_value }
  end

  context 'with option `only` as an array' do
    context 'with no elements' do
      subject { enum.to_h(only: []) }
      it { should eq all_keys }
    end

    context 'with one element' do
      subject { enum.to_h(only: [:value]) }
      it { should eq only_value }
    end

    context 'with more than one element' do
      subject { enum.to_h(only: [:label, :value]) }
      it { should eq value_and_label }
    end

    context 'with an unknown key' do
      it 'should raise an error' do
        expect { enum.to_h(only: :foo) }.to raise_error('Unknown keys for enum')
      end
    end
  end

  context 'with option `except` as a symbol' do
    subject { enum.to_h(except: :key) }
    it { should eq value_and_label }
  end

  context 'with option `except` as an array' do
    context 'with no elements' do
      subject { enum.to_h(except: []) }
      it { should eq all_keys }
    end

    context 'with one element' do
      subject { enum.to_h(except: [:key]) }
      it { should eq value_and_label }
    end

    context 'with more than one element' do
      subject { enum.to_h(except: [:label, :key]) }
      it { should eq only_value }
    end

    context 'with an unknown key' do
      it 'should raise an error' do
        expect { enum.to_h(except: :foo) }.to raise_error('Unknown keys for enum')
      end
    end
  end
end
