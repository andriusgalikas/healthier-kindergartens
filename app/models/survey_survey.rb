# == Schema Information
#
# Table name : survey_surveys
#
#  name              :string
#  description       :text
#  attempts_number   :integer,       default: 0
#  finished          :boolean,       default: false
#  active            :boolean,       default: true
#  created_at        :datetime
#  updated_at        :datetime
#  survey_subject_id :integer
#  weight            :integer,       default: 0

class SurveySurvey < ActiveRecord::Base
  belongs_to :survey_subjects
end
