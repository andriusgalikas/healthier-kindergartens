# == Schema Information
#
# Table name: survey_attempts
#
#  participant_id   :integer
#  participant_type :string
#  survey_id        :integer
#  winner           :boolean
#  score            :integer


class SurveyAttempts < ActiveRecord::Base
  belongs_to :surveys
end
