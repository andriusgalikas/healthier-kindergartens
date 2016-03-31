# == Schema Information
#
# Table name: daycares
#
#  id            :integer          not null, primary key
#  name          :string
#  address_line1 :string
#  postcode      :string
#  country       :string
#  telephone     :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Daycare < ActiveRecord::Base
    has_many :departments 
    has_many :children,                                 through: :departments
    has_many :parents,                                  -> { (where(role: 0)) }, class_name: 'User'
    has_many :workers,                                  -> { (where(role: 1)) }, class_name: 'User'
    has_many :managers,                                 -> { (where(role: 2)) }, class_name: 'User'

    has_many :todos
    has_many :global_completed_todos,                   through: :todos, source: :completed_todos
    has_many :global_incomplete_todos,                  through: :todos, source: :incomplete_todos
    has_many :global_available_todos,                   through: :todos, source: :available_todos

    has_many :local_completed_todos,                    through: :departments, source: :completed_todos
    has_many :local_incomplete_todos,                   through: :departments, source: :incomplete_todos
    has_many :local_available_todos,                    through: :departments, source: :available_todos

    validates :name, :address_line1, :postcode,
                :country, :telephone,                   presence: true


    def all_completed_todos
        global_completed_todos + local_completed_todos
    end

    def all_incomplete_todos
        global_incomplete_todos + local_incomplete_todos
    end

    def all_available_todos
        global_available_todos + local_available_todos
    end
end
