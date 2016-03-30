# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string
#  attachable_id   :integer
#  attachable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :attachment do
    file "MyString"
    attachable_id 1
    file "MyString"
    attachable_type "MyString"
  end
end
