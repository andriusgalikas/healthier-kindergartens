# == Schema Information
#
# Table name: illnesses
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :illness do
    code { Faker::Lorem.characters(10) }
    name { Faker::Lorem.word }
  end
end
