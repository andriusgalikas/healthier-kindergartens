class TodoFrequenciesJob < ActiveJob::Base
    queue_as :todo

    def perform *args
        TodoComplete.active.each do |todo_complete|
            if todo_complete.created_at < todo_complete.todo.frequency_to_time
                todo_complete.inactive!
            end
        end
    end
end
