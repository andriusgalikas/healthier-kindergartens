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

class TodoTaskComplete < ActiveRecord::Base
    belongs_to :submitter,                                                      class_name: 'User'
    belongs_to :todo_complete
    belongs_to :todo_task

    validates :submitter_id, :todo_complete_id, :todo_task_id,                  presence: true

    enum result: [:pending, :pass, :failed]
end
