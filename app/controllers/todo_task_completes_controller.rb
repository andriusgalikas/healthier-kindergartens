class TodoTaskCompletesController < ApplicationController

    def update
        set_todo_task_complete
        update_task_to_pass
        redirect_to dashboard_url, notice: 'Successfully marked task as completed.'
    end

    private

    def set_todo_task_complete
        @todo_task_complete = current_user.task_completes.find(params[:id])
    end

    def update_task_to_pass
        @todo_task_complete.update(completion_date: Time.now, result: 1)
    end
end