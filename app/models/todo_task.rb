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
#  task_type   :integer          default("0")
#

class TodoTask < ActiveRecord::Base
    has_many :tasks_complete,                                       class_name: 'TodoTaskComplete'
    belongs_to :todo

    validates :title, :description,                                 presence: true

    enum task_type: [:global, :local]

    before_save :is_admin_global?
    before_destroy :is_admin_global?

    # => Checks if user is admin or global if updating, saving or destroying a todo record
    #
    def is_admin_global?
        if todo.global? && !todo.user.admin?
            errors.add :base, "You do not have permission to save or destroy this Todo Task."
            return false
        end
    end
end
