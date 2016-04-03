FactoryGirl.define do
  factory :user do
    name "Test User"
    username "test_user"
    email "test@example.com"
    password "please123"
    confirmed_at Time.now
  end
end
