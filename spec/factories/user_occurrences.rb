# == Schema Information
#
# Table name: user_occurrences
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  todo_id    :integer
#  status     :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :user_occurrence do
    user_id 1
    todo_id 1
    status 1
  end
end
