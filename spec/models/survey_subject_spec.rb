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

require 'rails_helper'

RSpec.describe SurveySubject, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
