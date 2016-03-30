# == Schema Information
#
# Table name: subjects
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Subject < ActiveRecord::Base
    has_many :todo_subjects
    has_many :todos,                                through: :todo_subjects

    validates :title, :description,                 presence: true
end
