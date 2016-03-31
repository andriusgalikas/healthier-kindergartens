# == Schema Information
#
# Table name: todo_task_completes
#
#  id               :integer          not null, primary key
#  submitter_id     :integer
#  todo_complete_id :integer
#  todo_task_id     :integer
#  completion_date  :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  result           :integer          default("0")
#

require 'rails_helper'

RSpec.describe TodoTaskComplete, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
