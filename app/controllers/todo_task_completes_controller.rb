class TodoTaskCompletesController < ApplicationController

    def update
        set_todo_task_complete
    end

    private

    def set_todo_task_complete
        @todo_task_complete = current_user.task_completes.find(params[:id])
    end
end