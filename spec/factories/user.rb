FactoryGirl.define do
  factory :user do
    email 'user@example.com'
    name 'User'
    password 'secretpassword'

    factory :admin do
      email 'admin@example.com'
      name 'Admin'
      admin true
    end

    factory :user_2 do
      email 'user_2@example.com'
      name 'User 2'
    end
  end
end
