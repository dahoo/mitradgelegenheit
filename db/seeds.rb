# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


track = Track.create name: 'HU Berlin',
             distance: 5,
             time: 'mittwochs 9:45'

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

track.starts = [Start.create(latitude: 52.5390921,
                             longitude: 13.4240913,
                             description: 'Start Prenzl. Allee/Danziger Str. mitt. donn. frei. 9:45(zur HU Berlin)')]

track.ends = []

[[52.5206603, 13.3919048, 'Ziel HU Bibliothek mittwochs, donnerstags, freitags(Ankunft ~10:10)'],
 [52.5172132, 13.3944798, 'Ziel: HU Audimax mittwochs, donnerstags + freitags Ankunft ~10:05 Uhr'],
 [52.5199291, 13.4046936, 'Ziel: WiWi-Fakultät (HU) mittwochs, donnerstags, freitags(Ankunft 10 Uhr)']].each do |lat, long, description|
  track.ends.append(End.create latitude: lat,
                               longitude: long,
                               description: description)
end
