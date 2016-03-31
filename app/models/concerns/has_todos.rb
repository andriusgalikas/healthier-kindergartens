module HasTodos
    extend ActiveSupport::Concern

    included do
        has_many :todos 
        has_many :completed_todos,                          through: :todos
        has_many :incomplete_todos,                         through: :todos
    end
end