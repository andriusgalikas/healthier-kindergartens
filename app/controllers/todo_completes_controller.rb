class TodoCompletesController < ApplicationController

    def create
        set_todo
        create_todo_complete
        create_todo_task_completes
        redirect_to dashboard_url, notice: "Successfully started a task."
    end

    private

    def set_todo
        @todo ||= current_user.daycare.all_todos.find(params[:todo_id])
    end

    def create_todo_complete
        @todo_complete = current_user.todo_completes.create(todo_id: @todo.id)
    end

    def create_todo_task_completes
        @todo.tasks.each do |task|
            current_user.task_completes.create(todo_complete_id: @todo_complete.id, todo_task_id: task.id)
        end
    end
end