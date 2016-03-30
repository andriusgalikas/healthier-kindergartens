# == Schema Information
#
# Table name: todo_tasks
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  todo_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :todo_task do
    title "MyString"
    description "MyText"
    todo_id 1
  end
end
