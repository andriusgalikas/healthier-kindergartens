# == Schema Information
#
# Table name: subjects
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :subject do
    title "MyString"
    description "MyText"
  end
end
