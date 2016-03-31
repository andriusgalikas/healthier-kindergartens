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
#

class TodoTaskComplete < ActiveRecord::Base
    belongs_to :submitter,                              class_name: 'User'
    belongs_to :todo_complete
    belongs_to :todo_task
end
