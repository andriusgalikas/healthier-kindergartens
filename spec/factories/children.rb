# == Schema Information
#
# Table name: children
#
#  id            :integer          not null, primary key
#  name          :string
#  parent_id     :integer
#  department_id :integer
#  birth_date    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :child do
    name "MyString"
    parent_id 1
    department_id 1
    birth_date "2016-03-30 19:58:31"
  end
end
