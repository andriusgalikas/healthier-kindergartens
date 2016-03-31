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
    has_many :task_completes,                   class_name: 'TodoTaskComplete'
    belongs_to :submitter,                      class_name: 'User'
    belongs_to :todo

    validates :submitter_id, :todo_id,          presence: true

    enum status: [:active, :inactive]
end
