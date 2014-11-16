FactoryGirl.define do
  factory :track do
    name 'Mitradgelegenheit'
    time 'montags 8:00'
    track_points {[FactoryGirl.create(:track_point),
                   FactoryGirl.create(:track_point_2),
                   FactoryGirl.create(:track_point_3)]}
    starts {[FactoryGirl.create(:start)]}
    ends   {[FactoryGirl.create(:end)]}


    factory :track_attributes do
      name 'Mitradgelegenheit'
      time 'montags 8:00'
      track_points {[FactoryGirl.create(:track_point),
                     FactoryGirl.create(:track_point_2),
                     FactoryGirl.create(:track_point_3)].map{ |tp| "#{tp.latitude},#{tp.longitude}" }.join(';')}
      starts {[FactoryGirl.create(:start)].map{ |tp| "#{tp.latitude},#{tp.longitude}" }.join(';')}
      ends   {[FactoryGirl.create(:end)].map{ |tp| "#{tp.latitude},#{tp.longitude}" }.join(';')}
    end

    factory :new_track_attributes do
      name 'Mitradgelegenheit 2'
      time 'freitags 8:00'
      track_points {[FactoryGirl.create(:track_point),
                     FactoryGirl.create(:track_point_2),
                     FactoryGirl.create(:track_point_3)].map{ |tp| "#{tp.latitude},#{tp.longitude}" }.join(';')}
      starts {[FactoryGirl.create(:start)].map{ |tp| "#{tp.latitude},#{tp.longitude}" }.join(';')}
      ends   {[FactoryGirl.create(:end)].map{ |tp| "#{tp.latitude},#{tp.longitude}" }.join(';')}
    end
  end
end