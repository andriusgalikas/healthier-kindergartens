class Manager::TodosController < ApplicationController
	layout 'dashboard'
	before_action -> { authenticate_role!(["manager"]) }
	before_action :authenticate_subscribed!

	def search
		set_query
		set_accessible_todos
		search_todos
	end

	def show
		set_todo
	end

	def edit
		set_todo
	end

	def update
		set_todo
		set_new_todo if @todo.global?
		if (@old_todo.present? ? @todo.save : @todo.update(todo_params))
			redirect_to manager_todo_path(@todo), notice: 'Todo was successfully updated.'
		else
            @errors = @todo.errors.full_messages
			@todo = @old_todo
			@todo.attributes = todo_params
			render :edit
		end
	end

	def destroy
		set_todo
        set_global_todo if @todo.local?
        hide_todo_from_dashboard
		@todo.destroy unless @todo.global?
		redirect_to dashboard_manager_todos_path, notice: 'Todo was successfully destroyed.'
	end

	def set_date_range
		set_todo
	end

	def report
		set_todo
		set_accessible_todos
		set_report_todo_completes
	end

	private

	def set_todo
		@todo = Todo.find(params[:id])
	end

	def set_new_todo
		@old_todo = @todo
		@todo = Todo.new(todo_params)
		@old_todo.tasks.each do |task|
			new_task = @todo.tasks.build
			new_task.attributes = task.dup.attributes

      task.sub_tasks.each do |sub_task|
        new_sub_task = task.sub_tasks.build
        new_sub_task.attributes  = sub_task.dup.attributes
      end
    end

    new_icon = @todo.build_icon
    new_icon.duplicate_file(@old_todo.icon)
		@todo.daycare = current_user.daycare
	end

	def new_icon_attachment
		@todo.build_icon
	end

  	def todo_params
  		params.require(:todo).permit(
        :title,
        :iteration_type,
        :frequency,
        :completion_date_type,
        :completion_date_value,
        :daycare_id,
        tasks_attributes: [:_destroy, :id, :title, :description, :todo_id, :task_type,
                           sub_tasks_attributes: [:id, :_destroy, :title, :sub_task_type]],
        icon_attributes: [:id, :attachable_type, :attachable_id, :file]
      ).merge(user_id: current_user.id)
  	end

  	def set_query
  		@query = "%#{params[:query]}%"
  	end

  	def set_accessible_todos
  		@ids = (current_user.completed_todos + current_user.incomplete_todos + current_user.available_todos).map(&:id)
  	end

  	def set_report_todo_completes
  		@todo_completes = TodoComplete.generate_report(@ids, params[:start_date], params[:end_date])
  	end

  	def search_todos
  		@todos ||= Todo.search(@query, @ids, params[:page], 100, 300)
  	end

    def set_global_todo
        @global_todo = Todo.global.find_by_title(@todo.title)
    end

    def hide_todo_from_dashboard
        binding.pry
        UserTodoDestroy.create(todo_id: (@global_todo ||= @todo).id, user_id: current_user.id)
    end
end
