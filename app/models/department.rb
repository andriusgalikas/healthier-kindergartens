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

    validates :name, :daycare_id,                       presence: true
end
