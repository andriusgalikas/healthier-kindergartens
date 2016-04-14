class Manager::Reports::TodosController < ApplicationController
    layout 'dashboard'

    def index
        
    end

    def show
        set_global_todo
        set_report_todo_completes
    end

    def search
        set_query
        set_accessible_todos
        search_todos
    end

    def set_date_range
        set_global_todo
    end

    private

    def set_global_todo
        @todo = Todo.find(params[:todo_id])
    end

    def set_accessible_todos
        @ids = (current_user.completed_todos + current_user.incomplete_todos + current_user.available_todos).map(&:id)
    end

    def set_query
        @query = "%#{params[:query]}%"
    end

    def set_report_todo_completes
        @todo_completes = TodoComplete.generate_report(@todo.id, params[:start_date], params[:end_date])
    end

    def search_todos
        @todos ||= Todo.search(@query, @ids, params[:page], 100, 300)
    end
end