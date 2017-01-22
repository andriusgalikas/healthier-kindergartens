# == Schema Information
#
# Table name: locale_logos
#
#  id                :integer          not null, primary key
#  logo_type         :integer
#  logo_file_name    :string
#  logo_content_type :string
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#  language          :string
#  description       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe LocaleLogo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
