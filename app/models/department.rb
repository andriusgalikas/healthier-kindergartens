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
    has_many :children,                                 class_name: 'Child'

    has_many :department_todos
    has_many :todos,                                    through: :department_todos
    has_many :completed_todos,                          through: :todos
    has_many :incomplete_todos,                         through: :todos
    has_many :available_todos,                          through: :todos

    validates :name, :daycare_id,                       presence: true
end
