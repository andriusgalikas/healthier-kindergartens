# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  source_id   :integer
#  source_type :string
#  target_id   :integer
#  archived    :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Notification < ActiveRecord::Base
  include Deactivatable

  belongs_to :source, polymorphic: true
  belongs_to :target, class_name: 'User'

end
