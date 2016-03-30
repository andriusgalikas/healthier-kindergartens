# == Schema Information
#
# Table name: attachments
#
#  id              :integer          not null, primary key
#  file            :string
#  attachable_id   :integer
#  attachable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Attachment < ActiveRecord::Base
    belongs_to :attachable,           polymorphic: true

    mount_uploader :file,             FileUploader

    validates :file,                  format: { with: /\.(gif|jpg|png)\z/i, message: "must be a URL for GIF, JPG, JPEG or PNG image." }
end
