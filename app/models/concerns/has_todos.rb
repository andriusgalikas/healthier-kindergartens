module HasTodos
    extend ActiveSupport::Concern

    included do
        # Worker/parent relations
        has_many :todo_completes,                                    foreign_key: 'submitter_id'
        has_many :completed_todo_completes,                          -> { where.not(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :incomplete_todo_completes,                         -> { where.not(id: nil).where(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'

        # Manager/admin relations
        has_many :local_todos,                                      through: :daycare
        has_many :global_todos,                                     through: :daycare

        def available_todos
            daycare.all_todos.reject{|t| active_todo_completes.map(&:todo_id).include? t.id }
        end

        def active_todo_completes
            (completed_todo_completes.active + incomplete_todo_completes.active)
        end
    end
end