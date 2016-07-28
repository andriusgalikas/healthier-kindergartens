# == Schema Information
#
# Table name: message_templates
#
#  id             :integer          not null, primary key
#  sub_subject_id :integer
#  target_role    :integer
#  content        :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  language       :string
#
# Indexes
#
#  index_message_templates_on_sub_subject_id  (sub_subject_id)
#

FactoryGirl.define do
  factory :message_template do

    target_role { ['worker'].to_json }
    content { Faker::Lorem.paragraph(10) }
    language { 'en' }

    association :sub_subject, factory: :message_subject
  end
end
