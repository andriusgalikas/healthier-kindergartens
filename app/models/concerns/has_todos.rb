module HasTodos
    extend ActiveSupport::Concern

    included do
        has_many :todos

        # Worker/parent relations
        has_many :todo_completes,                                    foreign_key: 'submitter_id', dependent: :destroy
        has_many :task_completes,                                    through: :todo_completes, dependent: :destroy
        has_many :sub_task_completes,                                through: :task_completes, dependent: :destroy
        has_many :completed_todo_completes,                          -> { where.not(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :completed_recurring_todo_completes,                -> { where.not(completion_date: nil).includes(:todo).where(todos: { iteration_type: 1} ) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :incomplete_todo_completes,                         -> { where.not(id: nil).where(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :completed_todos,                                  -> { includes(:todo_completes).where.not(todo_completes: { completion_date: nil } ) }, class_name: 'Todo'
        has_many :incomplete_todos,                                 -> { includes(:todo_completes).where.not(todo_completes: { id: nil } ).where(todo_completes: { completion_date: nil } ) }, class_name: 'Todo'

        has_many :todo_destroys,                                    class_name: 'UserTodoDestroy'

        # Manager/admin relations
        has_many :local_todos,                                      through: :daycare
        has_many :global_todos,                                     through: :daycare

        # => Sets the available todos for a user
        #
        def available_todos
            all_todos.reject{|t| unavailable_todos.map(&:todo_id).include? t.id }
        end

        # => Sets the unavailable todos for a user
        #
        def unavailable_todos
            (completed_recurring_todo_completes.active + incomplete_todo_completes.active)
        end

        def all_todos
            daycare.all_todos.reject{|dt| daycare.todo_destroys.map(&:todo_id).include? (dt.id) }
        end
    end
end
