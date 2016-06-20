# == Schema Information
#
# Table name: affiliates
#
#  id             :integer          not null, primary key
#  name           :string
#  address        :string
#  postcode       :string
#  country        :string
#  telephone      :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  url            :string
#
# Indexes
#
#  index_affiliates_on_name  (name)
#

class Affiliate < ActiveRecord::Base
  belongs_to :partner, class_name: 'User', foreign_key: 'parent_id'

  has_one :profile_image,  -> { where(attachable_type: 'AffiliateProfile') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy
  has_many :user_affiliates
  has_many :users,                                    through: :user_affiliates

  validates :name, :address, :postcode,
            :country, :telephone,                   presence: true

  accepts_nested_attributes_for :user_affiliates, :profile_image, allow_destroy: true
end
