# == Schema Information
#
# Table name: todos
#
#  id             :integer          not null, primary key
#  title          :string
#  due_date       :datetime
#  iteration_type :integer          default("0")
#  frequency      :integer          default("0")
#  daycare_id     :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Todo < ActiveRecord::Base
    has_many :tasks,                                                            class_name: 'TodoTask'
    has_many :tasks_complete,                                                   through: :tasks

    has_many :todo_completes

    has_many :department_todos
    has_many :departments,                                                      through: :department_todos

    has_many :completed_todos,                                                  -> { where.not(completion_date: nil) }, class_name: 'TodoComplete'
    has_many :incomplete_todos,                                                 -> { where(completion_date: nil) }, class_name: 'TodoComplete'                                        
    has_many :available_todos,                                                  -> { includes(:todo_completes).where(todo_completes: { id: nil } ) }

    belongs_to :daycare
    belongs_to :user

    validates :title, :due_date, :iteration_type,
                :frequency, :user_id,                                           presence: true


    scope :global,                                                              -> { where(daycare_id: nil) }
end
