class Admin::TodosController < AdminController

  def index
    @todos = Todo.all
  end

  def show
    set_todo
  end

  def new
    @todo = current_user.todos.build
    @todo.tasks.build
    set_departments
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:title, :iteration_type, :frequency, :user_id, department_ids: [], tasks_attributes: [:id, :title, :description, :todo_id])
    end
end
