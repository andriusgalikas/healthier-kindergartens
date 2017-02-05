# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  plan_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  terms            :boolean          default("false")
#  month            :integer
#  discount_code_id :integer
#  transaction_id   :integer
#  payment_mode_id  :integer
#

require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
