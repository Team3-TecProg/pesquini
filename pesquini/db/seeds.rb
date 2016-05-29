# This file should contain all the record creation needed to seed the database with its default values.

# This insertions in database are mado to make relationships between classes.
state_test = State.create(code: 777, name: "Estado teste", abbreviation: "Ab. teste")
enterprise_test = Enterprise.create(cnpj: "CNPJ teste", corporate_name: "corporate_name teste")
sanction_type_test = SanctionType.create(description: "Descrição teste",
						legal_foundation: "Fundamento legal teste",
						foundation_description: "Descrição do fundamento teste")


# State.
# In Brazil have 26 states and DF, so 27 states.
27.times do |i|
  State.create(code: "#{i}", name: "Estado ##{i}", abbreviation: "Ab. ##{i}")
end

# Enterprise.
# Create 5 generic enterprises.
5.times do |i|
  Enterprise.create(cnpj: "CNPJ ##{i}", corporate_name: "corporate_name ##{i}")
end

# SanctionType.
# Create 5 generic sanctions types.
5.times do |i|
	SanctionType.create(description: "Descrição ##{i}",
						legal_foundation: "Fundamento legal ##{i}",
						foundation_description: "Descrição do fundamento ##{i}")
end

require 'date'
# Sanction.
# Create 5 generic sanctions.
# This class have relationship with enterprise, sanction_type and state.
 5.times do |i|
 	Sanction.create(initial_date: DateTime.new(2016,1,1,00),
 					final_date: DateTime.new(2016,2,1,00),
 					process_number: "#{i}",
 					enterprise: enterprise_test,
 					sanction_type: sanction_type_test,
 					state: state_test)
end

# Payments.
# Create 5 generic payments.
5.times do |i|
	Payment.create(identifier: "Identificador ##{i}",
				   process_number: "Número do processo ##{i}",
				   initial_value: "##{i}")
end

# User
# Create one generic user.
User.create(login: "usuario", password_digest: "senha", remember_token: "")
