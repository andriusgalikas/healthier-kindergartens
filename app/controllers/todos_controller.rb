class TodosController < ApplicationController
    layout 'dashboard'
    before_action -> { authenticate_role!(["parentee", "worker"]) }

    def index
    end

    def search
        set_query
        set_accessible_todos
        @todos = Todo.search(@query, @ids, params[:page], 100, 300)
    end

    private

    def set_query
        @query = "%#{params[:query]}%"
    end

    def set_accessible_todos
      @ids = (current_user.global_todos + current_user.local_todos).map(&:id)
    end
end