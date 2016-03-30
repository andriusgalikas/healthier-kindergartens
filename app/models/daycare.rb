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

    validates :name, :address_line1, :postcode,
                :country, :telephone,                   presence: true
end
