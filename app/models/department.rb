# == Schema Information
#
# Table name: departments
#
#  id         :integer          not null, primary key
#  name       :string
#  daycare_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Department < ActiveRecord::Base
    belongs_to :daycare
    has_many :workers,                                  -> { where(role: 1) }, class_name: 'User'
    has_many :children,                                 class_name: 'Child'

    has_many :department_todos
    has_many :todos,                                     through: :department_todos

    has_many :completed_todos,                          -> { complete }, through: :department_todos, source: :todo
    has_many :incomplete_todos,                         -> { incomplete }, through: :department_todos, source: :todo
    has_many :available_todos,                          -> { available }, through: :department_todos, source: :todo

    has_many :health_records,                           :as => :owner

    validates :name,                                    presence: true, uniqueness: { scope: :daycare_id }
end
