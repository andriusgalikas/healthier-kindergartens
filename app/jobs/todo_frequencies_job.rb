class TodoFrequenciesJob < ActiveJob::Base
    queue_as :todo

    def perform *args
        Todo.all.each do |todo|
            todo.todo_completes.active
            
        end
    end
end
