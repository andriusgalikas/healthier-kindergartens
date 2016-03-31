# == Schema Information
#
# Table name: todo_task_completes
#
#  id               :integer          not null, primary key
#  submitter_id     :integer
#  todo_complete_id :integer
#  todo_task_id     :integer
#  completion_date  :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :todo_task_complete do
    submitter_id 1
    todo_complete_id 1
    todo_task_id 1
    completion_date "2016-03-31 15:59:47"
  end
end
