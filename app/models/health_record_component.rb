# == Schema Information
#
# Table name: health_record_components
#
#  id               :integer          not null, primary key
#  health_record_id :integer
#  code             :string
#  value            :string
#  deactivate_at    :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_health_record_components_on_health_record_id  (health_record_id)
#

class HealthRecordComponent < ActiveRecord::Base

  belongs_to :health_records

  validates :health_record_id, :code,              presence: true
end
