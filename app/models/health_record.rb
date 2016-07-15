# == Schema Information
#
# Table name: health_records
#
#  id             :integer          not null, primary key
#  protocol_code  :string
#  owner_id       :integer
#  owner_type     :string
#  recorder_id    :integer
#  recorder_type  :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class HealthRecord < ActiveRecord::Base

  belongs_to :owner,                                       polymorphic: true
  belongs_to :recorder,                                    polymorphic: true
  has_many   :health_record_components

  validates :protocol_code, :owner_id, :recorder_id,       presence: true
end
