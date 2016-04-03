class TodoFrequenciesJob < ActiveJob::Base
    queue_as :todo

    def perform *args
        TodoComplete.active.each do |todo_complete|
            if todo_complete.created_at < todo_complete.todo.frequency_to_time
                todo_complete.inactive!
                todo_complete.task_completes.update_all(result: 2)
                UserOcurrence.active.where(todo_id: todo_complete.todo.id).update_all(status: 1)
            end
        end
    end
end
