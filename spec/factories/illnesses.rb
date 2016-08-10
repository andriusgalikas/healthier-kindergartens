FactoryGirl.define do
  factory :illness do
    code Faker::Lorem.characters(10)
    name Faker::Lorem.word
  end
end
