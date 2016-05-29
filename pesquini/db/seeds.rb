# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#State
#In Brazil have 26 states and DF, so 27 states.
27.times do |i|
  State.create(code: "#{i}", name: "Estado ##{i}", abbreviation: "Ab. ##{i}")
end

#Enterprise
#Create 5 generic enterprises.
5.times do |i|
  Enterprise.create(cnpj: "CNPJ ##{i}", corporate_name: "corporate_name ##{i}")
end

#SanctionType
#create 5 generic sanctions types.
5.times do |i|
	SanctionType.create(description: "Descrição ##{i}",
						legal_foundation: "Fundamento legal ##{i}",
						foundation_description: "Descrição do fundamento ##{i}")
end
