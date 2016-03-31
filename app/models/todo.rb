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

    belongs_to :daycare
    belongs_to :user

    scope :complete,                                                            -> { includes(:todo_completes).where.not(todo_completes: { completion_date: nil } ) }
    scope :incomplete,                                                          -> { includes(:todo_completes).where.not(todo_completes: { id: nil } ).where(todo_completes: { completion_date: nil } )  }                                        
    scope :available,                                                           -> { includes(:todo_completes).where(todo_completes: { id: nil } ) }
    scope :global,                                                              -> { where(daycare_id: nil) }

    delegate :complete, :incomplete, :available,                                to: [:daycare, :department]

    validates :title, :due_date, :iteration_type,
                :frequency, :user_id,                                           presence: true

    def global?
        daycare_id.nil? ? true : false
    end
end