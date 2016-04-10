# == Schema Information
#
# Table name: survey_subjects
#
#  id          :integer          not null, primary key
#  title       :string
#  daycare_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

class SurveySubject < ActiveRecord::Base
    has_one :icon,                                 -> { where(attachable_type: 'SurveySubject') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy
    has_many :surveys,                              class_name: Survey::Survey
    belongs_to :daycare

    validates :title, :description,                 presence: true
end
