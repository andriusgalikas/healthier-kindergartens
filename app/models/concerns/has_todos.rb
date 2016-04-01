module HasTodos
    extend ActiveSupport::Concern

    included do
        has_many :todo_completes,                           foreign_key: 'submitter_id'
        has_many :completed_todos,                          -> { where.not(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
        has_many :incomplete_todos,                         -> { where.not(id: nil).where(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
    end
end