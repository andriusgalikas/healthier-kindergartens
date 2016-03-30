# == Schema Information
#
# Table name: todo_subjects
#
#  id         :integer          not null, primary key
#  todo_id    :integer
#  subject_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class TodoSubject < ActiveRecord::Base
    belongs_to :subject
    belongs_to :todo

    validates :subject_id, :todo_id,                        presence: true
end
