# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
p "Create users..."
User.create(name: 'Tareq', email: "tareqgholam@daycare.org", role: 3, password: "mypassword", password_confirmation: "mypassword")

p "Create subjects..."
subjects = ['Food Handling', 'Outbreak Control Strategies', 'Exclusion Of Sick Children', 'Preventive Diapering', 'Cleaning Bodily Fluids', 'Preventive Hand Washing']
subjects.map{|s| Subject.create(title: s) }