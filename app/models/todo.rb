# == Schema Information
#
# Table name: todos
#
#  id             :integer          not null, primary key
#  title          :string
#  iteration_type :integer          default("0")
#  frequency      :integer          default("0")
#  daycare_id     :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Todo < ActiveRecord::Base
    has_many :tasks,                                                            class_name: 'TodoTask', dependent: :destroy
    has_many :tasks_complete,                                                   through: :tasks

    has_many :todo_completes,                                                   dependent: :destroy

    has_many :department_todos
    has_many :departments,                                                      through: :department_todos, dependent: :destroy

    belongs_to :daycare
    belongs_to :user

    scope :complete,                                                            -> { includes(:todo_completes).where.not(todo_completes: { completion_date: nil } ) }
    scope :incomplete,                                                          -> { includes(:todo_completes).where.not(todo_completes: { id: nil } ).where(todo_completes: { completion_date: nil } )  }                                        
    scope :available,                                                           -> { includes(:todo_completes).where(todo_completes: { id: nil } ) }
    scope :global,                                                              -> { where(daycare_id: nil) }

    delegate :complete, :incomplete, :available,                                to: [:daycare, :department]

    validates :title, :iteration_type,
                :frequency, :user_id,                                           presence: true

    enum iteration_type: [:single, :recurring]
    enum frequency: [:day, :week, :month, :year]

    accepts_nested_attributes_for :tasks

    def global?
        daycare_id.nil? ? true : false
    end

    def frequency_to_time
        day? ? 1.days.ago.to_date : week? ? 7.days.ago.to_date : month? ? 1.month.ago.to_date : 1.year.ago.to_date 
    end
end
