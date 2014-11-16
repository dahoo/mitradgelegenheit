FactoryGirl.define do
  factory :track_point do
    latitude 52.13
    longitude 13.14
    index 0

    factory :track_point_2 do
      latitude 52.15
      longitude 13.14
      index 1
    end

    factory :track_point_3 do
      latitude 52.16
      longitude 13.16
      index 2
    end
  end
end