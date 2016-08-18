# == Schema Information
#
# Table name: user_profiles
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  phone_number              :integer
#  physical_address          :string
#  web_address               :string
#  about_yourself            :string
#  education                 :string
#  online_presence           :boolean          default("true")
#  created_at                :datetime
#  updated_at                :datetime
#  medical_specialization_id :integer
#  certifications            :text             default("{}"), is an Array
#

class UserProfile < ActiveRecord::Base
  belongs_to :user
  has_one    :profile_image,  -> { where(attachable_type: 'UserProfile') }, class_name: 'Attachment', foreign_key: 'attachable_id', dependent: :destroy
  has_one    :medical_specialization

  accepts_nested_attributes_for :profile_image
end
