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

    validates :submitter_id,                    uniqueness: { scope: [:active, :todo_id]}

    enum status: [:active, :inactive]

    validate :occurrence_presence

    def occurrence_presence
        unless UserOccurrence.active.where(todo_id: todo_id, user_id: submitter_id).empty?
            errors.add(:occurrence, "You can't start this task again until it has refreshed.")
            return false
        end
    end

    def complete?
        !completion_date.nil? ? true : false
    end

    def pass?
        task_completes.map(&:result).exclude?("pending") && task_completes.map(&:result).exclude?("failed") ? true : false
    end

    def pending?
        task_completes.map(&:result).exclude?("failed") ? true : false
    end
end
