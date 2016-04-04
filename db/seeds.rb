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
manager = User.create(name: 'Manager User', email: "manager@daycare.org", role: 2, password: "mypassword", password_confirmation: "mypassword")
manager2 = User.create(name: 'Manager 2 User', email: "manager2@daycare.org", role: 2, password: "mypassword", password_confirmation: "mypassword")
User.create(name: 'Worker User', email: "worker@daycare.org", role: 1, password: "mypassword", password_confirmation: "mypassword")
User.create(name: 'Parent User', email: "parent@daycare.org", role: 0, password: "mypassword", password_confirmation: "mypassword")

p "Creating daycares and departments..."
2.times do
    daycare = Daycare.create(name: Faker::Company.name, address_line1: Faker::Address.street_address, postcode: Faker::Address.zip_code, country: Faker::Address.country, telephone: Faker::PhoneNumber.phone_number)
    2.times do
        daycare.departments.create(name: "Department-#{Faker::Lorem.word}")
    end
end

p "Assigning users daycares..."
User.where.not(role: 3).first(2).zip(Daycare.all).each do |user, daycare|
    user.create_user_daycare(daycare_id: daycare.id)
end
User.where.not(role: 3).last(2).zip(Daycare.all).each do |user, daycare|
    user.create_user_daycare(daycare_id: daycare.id)
end

p "Creating example todos..."
8.times do
    todo = Todo.new(title: "Todo-#{Faker::Lorem.word}", iteration_type: rand(0..1), frequency: rand(0..3), user_id: admin.id)
    todo.create_icon(file: File.open(File.join(Rails.root, '/lib/dummy_assets/ruby-icon.png')))
    todo.save!
    3.times do
        todo.tasks.create(title: "Task-#{Faker::Lorem.word}", description: Faker::Lorem.sentence)
    end
end

p "Assigning todos to departments..."
Todo.first(4).zip(Department.all).each do |todo, dp|
    todo.department_todos.create(department_id: dp.id)
end
Todo.last(4).zip(Department.all).each do |todo, dp|
    todo.department_todos.create(department_id: dp.id)
end



p "Creating plans..."
Plan.create(name: 'DayCare 30', price: 29.99, allocation: 30)
Plan.create(name: 'DayCare 50', price: 49.99, allocation: 50)
Plan.create(name: 'DayCare 100', price: 99.99, allocation: 100)

p "Creating discount codes..."
DiscountCode.create(code: 'FIRST100', value: 50)
DiscountCode.create(code: 'REDUCE15', value: 15)
DiscountCode.create(code: 'REDUCE25', value: 25)
DiscountCode.create(code: 'REDUCE50', value: 50)

