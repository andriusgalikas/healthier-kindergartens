class Admin::TodosController < AdminController

  def index
    @todos = Todo.global.all
  end

  def show
    set_todo
  end

  def new
    @todo = current_user.todos.build
    new_icon_attachment
    set_departments
    new_task
  end

  def edit
    set_departments
    set_todo
  end

  def create
    set_departments
    @todo = current_user.todos.build(todo_params)
    respond_to do |format|
      if @todo.save
        format.html { redirect_to admin_todos_url, notice: 'Todo was successfully created.' }
        format.json { render :show, status: :created, location: @todo }
      else
        new_icon_attachment
        format.html { render :new }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    set_todo
    set_departments
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to admin_todos_url, notice: 'Todo was successfully updated.' }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    set_todo
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to admin_todos_url, notice: 'Todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.global.find(params[:id])
    end

    def set_departments
      @departments ||= Department.all
    end

    def new_icon_attachment
      @todo.build_icon
    end

    def new_task
      @todo.tasks.build
      @todo.tasks[0].sub_tasks.build
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:title, :iteration_type, :frequency, :user_id, :completion_date_type, :completion_date_value, department_ids: [], tasks_attributes: [:_destroy, :id, :title, :description, :todo_id, sub_tasks_attributes: [:id, :title, :_destroy]], icon_attributes: [:id, :attachable_type, :attachable_id, :file])
    end
end
