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
    name "MyString"
    address_line1 "MyString"
    postcode "MyString"
    country "MyString"
    telephone "MyString"
  end
end
