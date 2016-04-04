# == Schema Information
#
# Table name: children
#
#  id            :integer          not null, primary key
#  name          :string
#  parent_id     :integer
#  department_id :integer
#  birth_date    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Child < ActiveRecord::Base
    has_one :profile_image,                                 -> { where(attachable_type: 'ChildProfile') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy
    belongs_to :parentee,                                   class_name: 'User', foreign_key: 'parent_id'
    belongs_to :department

    validates :name, :parent_id, :department_id,
                :birth_date,                                presence: true

    validates :profile_image,                               presence: true
end
