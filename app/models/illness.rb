# == Schema Information
#
# Table name: illnesses
#
#  id         :integer          not null, primary key
#  code       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Illness < ActiveRecord::Base

  has_many :symptoms

  validates :code, :name,          presence: true
  validates :code,                 uniqueness: true

  accepts_nested_attributes_for :symptoms, allow_destroy: true

end
