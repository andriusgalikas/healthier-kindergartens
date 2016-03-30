# == Schema Information
#
# Table name: todo_subjects
#
#  id         :integer          not null, primary key
#  todo_id    :integer
#  subject_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe TodoSubject, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
