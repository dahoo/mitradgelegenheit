FactoryGirl.define do
  factory :comment do
    text 'This is a comment'
    user
    track
  end
end
