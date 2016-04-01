require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
p "Create users..."
admin = User.create(name: 'Admin User', email: "admin@daycare.org", role: 3, password: "mypassword", password_confirmation: "mypassword")
User.create(name: 'Manager User', email: "manager@daycare.org", role: 2, password: "mypassword", password_confirmation: "mypassword")
User.create(name: 'Worker User', email: "worker@daycare.org", role: 1, password: "mypassword", password_confirmation: "mypassword")
User.create(name: 'Parent User', email: "parent@daycare.org", role: 0, password: "mypassword", password_confirmation: "mypassword")

p "Creating daycares and departments..."
3.times do
    daycare = Daycare.create(name: Faker::Company.name, address_line1: Faker::Address.street_address, postcode: Faker::Address.zip_code, country: Faker::Address.country, telephone: Faker::PhoneNumber.phone_number)
    2.times do
        daycare.departments.create(name: "Department-#{Faker::Lorem.word}")
    end
end

p "Creating example todos..."
5.times do
    todo = Todo.create(title: "Todo-#{Faker::Lorem.word}", iteration_type: rand(0..1), frequency: rand(0..3), user_id: admin.id)
    3.times do
        todo.tasks.create(title: "Task-#{Faker::Lorem.word}", description: Faker::Lorem.sentence)
    end
end

p "Assigning users daycares..."
User.all.each do |user|
    UserDaycare.create(daycare_id: Daycare.all.map(&:id).sample, user_id: user.id)
end



p "Creating plans..."
Plan.create(name: 'DayCare 30', price: 29.99)
Plan.create(name: 'DayCare 50', price: 49.99)
Plan.create(name: 'DayCare 100', price: 99.99)

p "Creating discount codes..."
DiscountCode.create(code: 'REDUCE15', value: 15)
DiscountCode.create(code: 'REDUCE25', value: 25)
DiscountCode.create(code: 'REDUCE50', value: 50)

