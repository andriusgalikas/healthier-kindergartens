require 'faker'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
p "Creating daycares and departments..."
2.times do
    daycare = Daycare.new(name: Faker::Company.name, address_line1: Faker::Address.street_address, postcode: Faker::Address.zip_code, country: Faker::Address.country, telephone: Faker::PhoneNumber.phone_number)
    2.times do
        daycare.departments.build(name: "Department-#{Faker::Lorem.word}")
    end
    daycare.save!
end

p "Create users..."
admin = User.create(name: 'Admin User', email: "admin@daycare.org", role: 3, password: "mypassword", password_confirmation: "mypassword")
manager = User.new(name: 'Manager User', email: "manager@daycare.org", role: 2, password: "mypassword", password_confirmation: "mypassword")
manager.build_user_daycare(daycare_id: Daycare.first.id)
manager.save!
manager2 = User.new(name: 'Manager 2 User', email: "manager2@daycare.org", role: 2, password: "mypassword", password_confirmation: "mypassword")
manager2.build_user_daycare(daycare_id: Daycare.second.id)
manager2.save!
worker = User.new(name: 'Worker User', email: "worker@daycare.org", role: 1, password: "mypassword", password_confirmation: "mypassword", department_id: Department.all.map(&:id).sample)
worker.build_user_daycare(daycare_id: Daycare.first.id)
worker.save!
parent = User.new(name: 'Parent User', email: "parent@daycare.org", role: 0, password: "mypassword", password_confirmation: "mypassword")
parent.build_user_daycare(daycare_id: Daycare.first.id)
child = parent.children.build(name: Faker::Name.name, department_id: Department.all.map(&:id).sample, birth_date: Faker::Date.between(10.years.ago, 3.years.ago))
child.build_profile_image(file: File.open(File.join(Rails.root, '/lib/dummy_assets/child-sample.jpg')))
parent.save!

p "Creating example todos..."
8.times do
    todo = Todo.new(title: "Todo-#{Faker::Lorem.word}", iteration_type: rand(0..1), frequency: rand(0..3), user_id: admin.id)
    todo.create_icon(file: File.open(File.join(Rails.root, '/lib/dummy_assets/ruby-icon.png')))
    todo.save!
    3.times do
        todo.tasks.create(title: "Task-#{Faker::Lorem.word}", description: Faker::Lorem.sentence)
    end
end

# p "Creating example todo completes..."
# Todo.all.each do |todo|
#     15.times do
#         todo_complete = todo.todo_completes.build(submitter_id: worker.id)
#         todo_complete.save(validate: false)
#         todo_complete.task_completes.each do |task|
#             task.update_column(:result, rand(0..2))
#             task.update_column(:completion_date, Faker::Date.between(3.month.ago, Date.today)) if task.pass?
#         end
#     end
# end
# TodoComplete.all.each do |todo_complete|
#     todo_complete.update_column(:created_at, Faker::Date.between(3.month.ago, Date.today))
# end

p "Assigning todos to departments..."
Todo.first(4).zip(Department.all).each do |todo, dp|
    todo.department_todos.create(department_id: dp.id)
end
Todo.last(4).zip(Department.all).each do |todo, dp|
    todo.department_todos.create(department_id: dp.id)
end



p "Creating plans..."
Plan.create(name: 'DayCare 30', price: 29.99, allocation: 30)
Plan.create(name: 'DayCare 60', price: 49.99, allocation: 60)
Plan.create(name: 'DayCare 90', price: 99.99, allocation: 90)
Stripe::Plans.put!

p "Creating discount codes..."
DiscountCode.create(code: 'FIRST100', value: 50)
DiscountCode.create(code: 'REDUCE15', value: 15)
DiscountCode.create(code: 'REDUCE25', value: 25)
DiscountCode.create(code: 'REDUCE50', value: 50)
Stripe::Coupons.put!

subjects = ['Food Handling', 'Outbreak Control Strategies', 'Exclusion Of Sick Children', 'Preventive Diapering', 'Cleaning Bodily Fluids', 'Preventive Hand Washing']

p "Creating subjects..."
subjects.each do |sub|
  subject = Subject.create(title: sub)
end

p "Creating Message Subject"
msg_subject = MessageSubject.create(title: 'Illness')

p "Creating Message Sub-subject"
msg_sub_subject = msg_subject.sub_subjects.create(title: 'Flu')

p "Creating Message Template"
msg_template = MessageTemplate.create(sub_subject_id: msg_sub_subject.id, target_role: 'worker', content: "The common cold, including chest cold and head cold, and seasonal flu are caused by viruses. Use over-the-counter cold medications to relieve symptoms including sore throat, runny nose, congestion, and cough. Flu symptoms are similar, but include fever, headache and muscle soreness. See a doctor who may prescribe antiviral medications Relenza or Tamiflu.")

p "Creating Message"
msg = Message.create(message_template_id: msg_template.id, owner_id: manager.id, title: msg_sub_subject.title, content: msg_template.content, target_role: ['worker'].to_json)

p "Creating Notification"
notif = msg.notifications.create(target_id: worker.id)
