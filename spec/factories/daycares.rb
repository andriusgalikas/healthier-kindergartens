# == Schema Information
#
# Table name: daycares
#
#  id            :integer          not null, primary key
#  name          :string
#  address_line1 :string
#  postcode      :string
#  country       :string
#  telephone     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :daycare do
    name          { Faker::Company.name }
    address_line1 { Faker::Address.street_address }
    postcode      { Faker::Address.zip_code }
    country       { Faker::Address.country }
    telephone     { Faker::PhoneNumber.phone_number }

    before(:create) do |daycare, evaluator|
      daycare.departments << (FactoryGirl.create :department, daycare: daycare)
    end
  end
end
