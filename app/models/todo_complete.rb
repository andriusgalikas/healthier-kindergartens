# == Schema Information
#
# Table name: todo_completes
#
#  id              :integer          not null, primary key
#  submitter_id    :integer
#  todo_id         :integer
#  completion_date :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  status          :integer          default("0")
#

class TodoComplete < ActiveRecord::Base
    has_many :task_completes,                   class_name: 'TodoTaskComplete', dependent: :destroy
    belongs_to :submitter,                      class_name: 'User'
    belongs_to :todo

    scope :incomplete,                          -> { where.not(id: nil).where(completion_date: nil) }

    validates :submitter_id, :todo_id,          presence: true

    validates :submitter_id,                    uniqueness: { scope: [:status, :todo_id] }, :if => :todo_recurring?

    enum status: [:active, :inactive]

    after_create :todo_task_completes
    after_create :assign_user_occurrence

    def complete?
        !completion_date.nil? ? true : false
    end

    def pass?
        task_completes.map(&:result).exclude?("pending") && task_completes.map(&:result).exclude?("failed") ? true : false
    end

    def pending?
        task_completes.map(&:result).exclude?("failed") ? true : false
    end

    def todo_recurring?
        todo.recurring? ? true : false
    end

    def todo_task_completes
        todo.tasks.each do |task|
            TodoTaskComplete.create(todo_complete_id: id, todo_task_id: task.id, submitter_id: submitter_id)
        end
    end

    def assign_user_occurrence
        UserOccurrence.create(user_id: submitter_id, todo_id: todo_id) if todo.recurring?
    end
end
