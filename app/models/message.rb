# == Schema Information
#
# Table name: messages
#
#  id                  :integer          not null, primary key
#  message_template_id :integer
#  owner_id            :integer
#  title               :string
#  content             :string
#  deactivated_at      :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  target_roles        :string           default("{}"), is an Array
#
# Indexes
#
#  index_messages_on_message_template_id  (message_template_id)
#

class Message < ActiveRecord::Base
  include Deactivatable
  include Permissions
  paginates_per 2

  belongs_to :message_template
  belongs_to :owner, class_name: 'User'
  has_many :notifications, :as => :source

  default_scope    { where(deactivated_at: nil) }
  scope :by_owner,  ->(owner_id) { where(owner_id: owner_id) }

  allowed_recipients.each do |target_role|
    define_method "for_#{target_role}?" do
      target_roles.include?(target_role)
    end
  end


end
