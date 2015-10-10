FactoryGirl.define do
  factory :track do
    name 'Mitradgelegenheit'
    user
    start_times { FactoryGirl.create_list(:start_time, 3) }
    track_points do
      [FactoryGirl.create(:track_point),
       FactoryGirl.create(:track_point_2),
       FactoryGirl.create(:track_point_3)]
    end
    starts { [FactoryGirl.create(:start)] }
    ends   { [FactoryGirl.create(:end)] }
    category 'other'
    distance '2'

    factory :track_attributes do
      name 'Mitradgelegenheit'
      time 'montags 8:00'
      track_points do
        [FactoryGirl.create(:track_point),
         FactoryGirl.create(:track_point_2),
         FactoryGirl.create(:track_point_3)].map {|tp| "#{tp.latitude},#{tp.longitude}" }.join(';')
      end
      starts { [FactoryGirl.create(:start)].map {|tp| "#{tp.latitude},#{tp.longitude}" }.join(';') }
      ends   { [FactoryGirl.create(:end)].map {|tp| "#{tp.latitude},#{tp.longitude}" }.join(';') }
    end

    factory :new_track_attributes do
      name 'Mitradgelegenheit 2'
      time 'freitags 8:00'
      track_points do
        [FactoryGirl.create(:track_point),
         FactoryGirl.create(:track_point_2),
         FactoryGirl.create(:track_point_3)].map {|tp| "#{tp.latitude},#{tp.longitude}" }.join(';')
      end
      starts { [FactoryGirl.create(:start)].map {|tp| "#{tp.latitude},#{tp.longitude}" }.join(';') }
      ends   { [FactoryGirl.create(:end)].map {|tp| "#{tp.latitude},#{tp.longitude}" }.join(';') }
    end

    factory :track_with_date do
      start_times { [FactoryGirl.create(:start_time_with_date)] }
    end

    factory :track_with_passed_date do
      start_times { [FactoryGirl.create(:start_time_with_passed_date)] }
    end

    trait :other_user do
      association :user, factory: :user_2
    end
  end
end
