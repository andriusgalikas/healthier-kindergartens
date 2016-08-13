# == Schema Information
#
# Table name: discussions
#
#  id             :integer          not null, primary key
#  title          :string
#  subject_id     :integer
#  subject_type   :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
# Indexes
#
#  index_discussions_on_subject_type_and_subject_id  (subject_type,subject_id)
#

class Discussion < ActiveRecord::Base
  has_many   :comments, dependent: :destroy
  has_many   :discussion_participants
  has_many   :notifications, :as => :source
  belongs_to :subject, polymorphic: true

  belongs_to :owner, class_name: 'User'
end
