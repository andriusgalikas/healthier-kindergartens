# == Schema Information
#
# Table name: todo_tasks
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  todo_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TodoTask < ActiveRecord::Base
    has_many :tasks_complete,                                       class_name: 'TodoTaskComplete'
    belongs_to :todo

    validates :title, :description,                                 presence: true
end
