module HasTodos
    extend ActiveSupport::Concern

    included do
        has_many :todos 
        # has_many :completed_todos
    end
end