# == Schema Information
#
# Table name : survey_answers
#
#  id          :integer
#  question_id :integer
#  weight      :integer,       default: 0
#  text        :string
#  correct     :boolean
#  created_at  :datetime
#  updated_at  :datetime

class SurveyOption < ActiveRecord::Base
  belongs_to :survey_questions, foreign_key: :question_id
end
