# == Schema Information
#
# Table name: user_daycares
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  daycare_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserDaycare, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
