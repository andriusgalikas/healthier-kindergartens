# == Schema Information
#
# Table name: message_subjects
#
#  id                :integer          not null, primary key
#  title             :string
#  parent_subject_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_message_subjects_on_parent_subject_id  (parent_subject_id)
#

require 'rails_helper'

RSpec.describe MessageSubject, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
