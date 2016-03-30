# == Schema Information
#
# Table name: children
#
#  id            :integer          not null, primary key
#  name          :string
#  parent_id     :integer
#  department_id :integer
#  birth_date    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Child, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
