# == Schema Information
#
# Table name: collaboration_invites
#
#  id            :integer          not null, primary key
#  child_id      :integer
#  inviter_id    :integer
#  invitee_email :string
#  status        :integer          default("0")
#

class CollaborationInvite < ActiveRecord::Base
  belongs_to :child
  belongs_to :inviter, class_name: 'User'

  validates :child_id, :inviter_id, :invitee_email, presence: true
  enum status: [:pending, :accepted]
end
