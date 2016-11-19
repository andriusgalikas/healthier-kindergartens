# == Schema Information
#
# Table name: locale_files
#
#  id                           :integer          not null, primary key
#  name                         :string
#  preview_link                 :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  file_file_name               :string
#  file_content_type            :string
#  file_file_size               :integer
#  file_updated_at              :datetime
#  online_training_file_name    :string
#  online_training_content_type :string
#  online_training_file_size    :integer
#  online_training_updated_at   :datetime
#  logo_file_name               :string
#  logo_content_type            :string
#  logo_file_size               :integer
#  logo_updated_at              :datetime
#  language_name                :string
#  language_short_name          :string
#

class LocaleFile < ActiveRecord::Base

  MIN_VIDEO_SIZE = 0.megabytes
  MAX_VIDEO_SIZE = 2048.megabytes
  LANGUAGE_NAMES = [['Deutsche', 'de'], ['English', 'en'], ['French', 'fr'], ['Spanish', 'sp']]

  has_attached_file :file, path: "locale_files/:id_partition/:filename"
  has_attached_file :online_training, path: "images/:id_partition/:filename"
  has_attached_file :logo, path: "video/:id_partition/:filename"

  validates_attachment_content_type :file, content_type: /./
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :online_training, content_type: /./, size: { in: MIN_VIDEO_SIZE..MAX_VIDEO_SIZE }

end
