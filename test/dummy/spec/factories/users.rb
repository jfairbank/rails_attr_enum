FactoryGirl.define do
  factory :user do
    [:admin, :editor, :author, :subscriber].each do |role_key|
      trait "role_#{role_key}".to_sym do
        #role User::Role.const_get(role_key.to_s.upcase)
        role role_key
      end
    end
  end
end
