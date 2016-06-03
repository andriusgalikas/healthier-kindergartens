# == Schema Information
#
# Table name: message_templates
#
#  id             :integer          not null, primary key
#  main_subject   :string
#  sub_subject    :string
#  target_role    :integer
#  content        :string
#  deactivated_at :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class MessageTemplate < ActiveRecord::Base
  include Deactivatable

  enum target_role: [:parentee, :worker, :manager]
end
