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
    belongs_to :todo

    validates :title, :description, :todo_id,                       presence: true
end
