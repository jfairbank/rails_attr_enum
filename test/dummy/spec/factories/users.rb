FactoryGirl.define do
  factory :user do
    [:admin, :editor, :author, :user].each do |role_key|
      trait "role_#{role_key}".to_sym do
        role User::Role.const_get(role_key.to_s.upcase)
      end
    end
  end
end
