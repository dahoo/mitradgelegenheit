FactoryGirl.define do
  factory :user do
    email 'admin@example.com'
    password 'secretpassword'

    factory :admin do
      admin true
    end
  end
end
