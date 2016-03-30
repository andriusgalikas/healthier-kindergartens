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
#  department_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Todo < ActiveRecord::Base
    has_many :tasks,                                                           class_name: 'TodoTask'
    belongs_to :department
    belongs_to :daycare
    belongs_to :user

    validates :title, :due_date, :iteration_type,
                :frequency, :daycare_id, :user_id,                             presence: true
end
