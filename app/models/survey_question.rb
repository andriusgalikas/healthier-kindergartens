# == Schema Information
#
# Table name : survey_questions
#
#  survey_id  :integer
#  text       :string
#  created_at :datetime
#  updated_at :datetime

class SurveyQuestion < ActiveRecord::Base
  belongs_to :survey_surveys, foreign_key: :survey_id
end
