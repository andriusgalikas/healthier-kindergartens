class TodoCompletesController < ApplicationController
    layout 'dashboard'
    before_action -> { authenticate_role!(["parentee", "worker"]) }
    before_action :authenticate_subscribed!

    def show
        set_todo_complete
        set_show_todo
    end

    def create
        set_todo
        create_todo_complete
        redirect_to todo_todo_complete_url(@todo, @todo_complete), notice: "Successfully started a task."
    end

    private

    def set_todo
        @todo = Todo.where(id: current_user.daycare.all_todos.map(&:id)).where(id: params[:todo_id]).first
    end

    def set_todo_complete
        @todo_complete = TodoComplete.includes(:todo, :task_completes).find(params[:id])
    end

    def set_show_todo
        @todo = @todo_complete.todo
    end

    def create_todo_complete
        @todo_complete = current_user.todo_completes.create(todo_id: @todo.id)
    end
end