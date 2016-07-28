# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  message_template_id :integer
#  owner_id            :integer
#  title               :string
#  content             :string
#  deactivated_at      :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  target_roles        :string           default("{}"), is an Array
#
# Indexes
#
#  index_messages_on_message_template_id  (message_template_id)
#

FactoryGirl.define do
  factory :message do
    association :message_template
    association :owner, factory: :user

    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph(10) }
    target_role {['worker'].to_json }

  end
end
