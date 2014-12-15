# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


track = Track.create! name: 'HU Berlin',
                     distance: 5,
                     link: 'https://www.facebook.com/events/878752632159575'

i = 0
[[52.5390921, 13.4240913],
 [52.5352811, 13.4218597],
 [52.5299555, 13.4184265],
 [52.5275013, 13.4161949],
 [52.5257781, 13.4141350],
 [52.5221226, 13.4088135],
 [52.5187279, 13.4019470],
 [52.5175266, 13.3989429],
 [52.5173699, 13.3927202],
 [52.5205624, 13.3919156]
].each do |lat, long|
  track.track_points.create latitude: lat,
                            longitude: long,
                            index: i
  i += 1
end

track.start_times = [StartTime.create(day_of_week: 2, time: (TimeOfDay.new 9, 45)),
                     StartTime.create(day_of_week: 3, time: (TimeOfDay.new 9, 45)),
                     StartTime.create(day_of_week: 4, time: (TimeOfDay.new 9, 45))]

track.starts = [Start.create(latitude: 52.5390921,
                             longitude: 13.4240913,
                             description: 'Prenzl. Allee/Danziger Str.')]

track.ends = []

[[52.5206603, 13.3919048, 25, 'HU Bibliothek'],
 [52.5172132, 13.3944798, 20, 'HU Audimax'],
 [52.5199291, 13.4046936, 15, 'WiWi-Fakultät (HU)']].each do |lat, long, time, description|
  track.ends.append(End.create latitude: lat,
                               longitude: long,
                               time: time,
                               description: description)
end

track2 = Track.create name: 'TU Berlin',
                      distance: 7,
                      link: 'https://www.facebook.com/events/346185055556761'

i = 0
[[52.4912212, 13.4204650],
 [52.4900583, 13.4197140],
 [52.4923774, 13.4114313],
 [52.4930176, 13.4088886],
 [52.4937753, 13.4044898],
 [52.4944024, 13.4005845],
 [52.4946506, 13.3992755],
 [52.4951732, 13.3980203],
 [52.4956958, 13.3971298],
 [52.4961857, 13.3956063],
 [52.4962902, 13.3949518],
 [52.4962836, 13.3939755],
 [52.4959570, 13.3906710],
 [52.4960485, 13.3896303],
 [52.4980472, 13.3890724],
 [52.4994123, 13.3889115],
 [52.4994841, 13.3885145],
 [52.5005553, 13.3874416],
 [52.5014435, 13.3863258],
 [52.5045195, 13.3824205],
 [52.5089863, 13.3767986],
 [52.5101159, 13.3767664],
 [52.5100049, 13.3753181],
 [52.5151828, 13.3598685],
 [52.5127865, 13.3229399]
].each do |lat, long|
  track2.track_points.create latitude: lat,
                             longitude: long,
                             index: i
  i += 1
end

track2.start_times = [StartTime.create(day_of_week: 2, time: (TimeOfDay.new 7, 30)),
                     StartTime.create(day_of_week: 2, time: (TimeOfDay.new 9, 20))]

[[52.4915739, 13.4204006, 0, 'Hohenstaufenplatz'],
 [52.4994384, 13.3888793, 15, 'Willy-Brand-Haus']
].each do |lat, long, time, description|
  track2.starts.create(latitude: lat,
                      longitude: long,
                      time: time,
                      description: description)
end

track2.ends.create latitude: 52.5122511,
                  longitude: 13.3269846,
                  time: 25,
                  description: 'TU Berlin'


track3 = Track.create name: 'Beuth Hochschule',
                      distance: 11

i = 0
[[52.4766641, 13.4187376],
 [52.4775920, 13.4262156],
 [52.4807155, 13.4252071],
 [52.4819439, 13.4248638],
 [52.4833813, 13.4249067],
 [52.4856550, 13.4242630],
 [52.4863737, 13.4244776],
 [52.4876934, 13.4255719],
 [52.4995037, 13.4181261],
 [52.5013063, 13.4192419],
 [52.5071056, 13.3981705],
 [52.5066615, 13.3905745],
 [52.5271880, 13.3871841],
 [52.5372780, 13.3746099],
 [52.5465306, 13.3592892],
 [52.5455356, 13.3575779],
 [52.5451686, 13.3569422]
].each do |lat, long|
  track3.track_points.create latitude: lat,
                             longitude: long,
                             index: i
  i += 1
end

track3.start_times = [StartTime.create(day_of_week: 2, time: (TimeOfDay.new 8, 50))]

track3.starts.create(latitude: 52.4766445,
                    longitude: 13.4186840,
                    description: 'Tempelhofer Feld (Oderstr)')

track3.ends.create latitude: 52.5451800,
                  longitude: 13.3568323,
                  time: 60,
                  description: 'Beuth-Hochschule'
