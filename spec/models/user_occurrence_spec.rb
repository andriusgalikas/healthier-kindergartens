# == Schema Information
#
# Table name: user_occurrences
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  todo_id    :integer
#  status     :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserOccurrence, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
