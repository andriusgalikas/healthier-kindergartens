# == Schema Information
#
# Table name: videos
#
#  id         :integer          not null, primary key
#  url        :string
#  language   :string
#  video_type :string
#  category   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Video < ActiveRecord::Base
	validates :url, presence: true
end
