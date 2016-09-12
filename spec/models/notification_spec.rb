# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  source_id   :integer
#  source_type :string
#  target_id   :integer
#  archived    :boolean          default("false")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Notification, type: :model do

  describe '#create' do
  end
end
