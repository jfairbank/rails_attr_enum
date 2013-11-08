require 'spec_helper'

describe 'User::Role.label_value_pairs' do
  let(:enum) { User::Role }

  before { default_user_roles }

  let :all_pairs do
    [[enum::ADMIN_LABEL,  enum::ADMIN],
     [enum::EDITOR_LABEL, enum::EDITOR],
     [enum::AUTHOR_LABEL, enum::AUTHOR],
     [enum::USER_LABEL,   enum::USER]]
  end

  context 'with no arguments' do
    subject { enum.label_value_pairs }

    it { should have(4).items }
    it { should eq(all_pairs) }
  end

  context 'with one argument' do
    subject { enum.label_value_pairs(:editor) }

    it { should have(1).item }
    it { should eq([[enum::EDITOR_LABEL, enum::EDITOR]]) }
  end

  context 'with more than one argument' do
    subject { enum.label_value_pairs(:author, :editor, :admin) }

    it { should have(3).items }

    it {
      should eq [[enum::ADMIN_LABEL,  enum::ADMIN],
                 [enum::EDITOR_LABEL, enum::EDITOR],
                 [enum::AUTHOR_LABEL, enum::AUTHOR]]
    }
  end
end
