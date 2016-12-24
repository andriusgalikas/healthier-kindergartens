# == Schema Information
#
# Table name: locale_urls
#
#  id         :integer          not null, primary key
#  url        :string
#  language   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe LocaleUrl, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
