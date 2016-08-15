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

    has_many :health_records,                               :as => :owner
    has_many :discussions,                                  -> { order "created_at ASC"}, :as => :subject

    validates :name, :department_id,
                :birth_date,                                presence: true

    validates :profile_image,                               presence: true

    accepts_nested_attributes_for :profile_image

    def age
      now = Time.now.utc.to_date
      now.year - birth_date.year - ((now.month > birth_date.month || (now.month == birth_date.month && now.day >= birth_date.day)) ? 0 : 1)
    end

end
