FactoryGirl.define do
  factory :symptom do
    code Faker::Lorem.characters(10)
    name Faker::Lorem.word

    illness
  end
end
