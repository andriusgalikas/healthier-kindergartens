# == Schema Information
#
# Table name: discount_code_users
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  discount_code_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class DiscountCodeUserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
