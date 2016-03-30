# == Schema Information
#
# Table name: todos
#
#  id             :integer          not null, primary key
#  title          :string
#  due_date       :datetime
#  iteration_type :integer          default("0")
#  frequency      :integer          default("0")
#  daycare_id     :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  department_id  :integer
#

FactoryGirl.define do
  factory :todo do
    title "MyString"
    due_date "2016-03-30 20:05:23"
    iteration_type 1
    frequency 1
    daycare_id 1
    user_id 1
  end
end
