class TodoTaskCompletesController < ApplicationController

    def update
        set_todo_task_complete
        set_todo
    end

    private

    def set_todo_task_complete
        @todo_task_complete = current_user.task_completes.find(params[:id])
    end

    def set_todo
        @todo = @todo_task_complete.todo
    end
end