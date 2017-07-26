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


  # enum affiliate_type: [:strategic, :certific]

  scope :search_by_type, ->(query, type) { where("name LIKE :search and affiliate_type = :type", search: "%#{query}%", type: type)}

  def affiliate_type_text
    case affiliate_type
    when 0
        I18n.t('register.partner_type.str')
    when 1
        I18n.t('register.partner_type.cer')
    end
  end

  def strategic?
    affiliate_type == 0
  end

  def certific?
    affiliate_type == 1
  end

end
