# == Schema Information
#
# Table name: comments
#
#  id             :integer          not null, primary key
#  discussion_id  :integer
#  owner_id       :integer
#  content        :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_comments_on_discussion_id  (discussion_id)
#  index_comments_on_owner_id       (owner_id)
#

class Comment < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :owner, class_name: 'User'
  has_many   :notifications, :as => :source

  delegate   :discussion_participants, to: :discussion
end
