module HasTodos
    extend ActiveSupport::Concern

    included do
        has_many :todos

        # Worker/parent relations
        has_many :todo_completes,                                    foreign_key: 'submitter_id', dependent: :destroy
        has_many :task_completes,                                    through: :todo_completes, dependent: :destroy
        has_many :completed_todo_completes,                          -> { where.not(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :completed_recurring_todo_completes,                -> { where.not(completion_date: nil).includes(:todo).where(todos: { iteration_type: 1} ) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :incomplete_todo_completes,                         -> { where.not(id: nil).where(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :completed_todos,                                  -> { includes(:todo_completes).where.not(todo_completes: { completion_date: nil } ) }, class_name: 'Todo'
        has_many :incomplete_todos,                                 -> { includes(:todo_completes).where.not(todo_completes: { id: nil } ).where(todo_completes: { completion_date: nil } ) }, class_name: 'Todo'

        # Manager/admin relations
        has_many :local_todos,                                      through: :daycare
        has_many :global_todos,                                     through: :daycare

        def available_todos
            daycare.all_todos.reject{|t| unavailable_todos.map(&:todo_id).include? t.id }
        end

        def unavailable_todos
            (completed_recurring_todo_completes.active + incomplete_todo_completes.active)
        end
    end
end