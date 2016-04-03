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

    after_update :assign_completion_date

    def assign_completion_date
        if todo_complete.task_completes.map(&:result).exclude?("pending")
            todo_complete.update_column(:completion_date, Time.now) 
            UserOccurrence.create(user_id: submitter_id, todo_id: todo_complete.todo_id) if todo_complete.todo.recurring?
        end
    end
end
