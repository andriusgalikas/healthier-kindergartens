# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  name       :string
#  price      :decimal(, )      default("0.0")
#  allocation :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  plan_type  :integer
#  language   :string
#  currency   :string
#

require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
