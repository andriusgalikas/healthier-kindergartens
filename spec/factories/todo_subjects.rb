# == Schema Information
#
# Table name: todo_subjects
#
#  id         :integer          not null, primary key
#  todo_id    :integer
#  subject_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :todo_subject do
    todo_id 1
    subject_id 1
  end
end
