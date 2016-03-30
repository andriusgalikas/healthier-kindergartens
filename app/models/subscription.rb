# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  plan_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Subscription < ActiveRecord::Base
    belongs_to :plan
    belongs_to :user

    validates :user_id, :plan_id,                       presence: true
end
