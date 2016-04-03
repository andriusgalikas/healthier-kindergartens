class TodoCompletesController < ApplicationController

    def create
        set_todo
        create_todo_complete
        redirect_to dashboard_url, notice: "Successfully started a task."
    end

    private

    def set_todo
        @todo = Todo.where(id: current_user.daycare.all_todos.map(&:id)).where(id: params[:todo_id]).first
    end

    def create_todo_complete
        @todo_complete = current_user.todo_completes.create(todo_id: @todo.id)
    end
end