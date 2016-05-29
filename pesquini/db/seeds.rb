# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#State
27.times do |i|
  State.create(code: "#{i}", name: "Estado ##{i}", abbreviation: "Ab. ##{i}")
end

#Enterprise
5.times do |i|
  Enterprise.create(cnpj: "CNPJ ##{i}", corporate_name: "corporate_name ##{i}")
end


