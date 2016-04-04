class TodosController < ApplicationController
    before_action -> { authenticate_role!(["parentee", "worker"]) }

    def show
        set_todo
    end

    private

    def set_todo
        @todo = Todo.where(id: current_user.daycare.all_todos.map(&:id)).where(id: params[:id]).first
    end
end