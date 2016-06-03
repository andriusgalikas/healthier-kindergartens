# == Schema Information
#
# Table name: message_subjects
#
#  id                :integer          not null, primary key
#  title             :string
#  parent_subject_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_message_subjects_on_parent_subject_id  (parent_subject_id)
#

class MessageSubject < ActiveRecord::Base
  belongs_to :parent_subject, class_name: 'MessageSubject'
  has_many   :sub_subjects, class_name: 'MessageSubject', foreign_key: 'parent_subject_id'

  has_many :message_templates, foreign_key: 'sub_subject_id'

  scope :main_subjects, -> { where(parent_subject_id: nil) }

  validates :title, presence: true
end
