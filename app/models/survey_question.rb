# == Schema Information
#
# Table name: survey_questions
#
#  id             :integer          not null, primary key
#  survey_id      :integer
#  text           :string
#  created_at     :datetime
#  updated_at     :datetime
#  deactivated_at :datetime
#

class SurveyQuestion < ActiveRecord::Base
  include Deactivatable

  belongs_to :survey_surveys, foreign_key: :survey_id
  has_many :options, class_name: SurveyOption, dependent: :destroy
end
