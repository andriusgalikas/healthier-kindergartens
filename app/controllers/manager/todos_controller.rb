class Manager::TodosController < ApplicationController
  layout 'dashboard'
  before_action -> { authenticate_role!(["manager"]) }
  before_action :subscribed_manager!

  def search
    set_query
    set_accessible_todos
    @todos = Todo.search(@query, @ids, params[:page], 100, 300)
  end

  def show
    set_global_todo
  end

  def new
    @todo = current_user.daycare.local_todos.build
    new_icon_attachment
    @todo.tasks.build
  end

  def edit
    set_todo
  end

  def create
    @todo = current_user.daycare.local_todos.build(todo_params)
    respond_to do |format|
      if @todo.save
        format.html { redirect_to dashboard_url, notice: 'Todo was successfully created.' }
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
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to dashboard_url, notice: 'Todo was successfully updated.' }
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
      format.html { redirect_to dashboard_url, notice: 'Todo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = current_user.daycare.local_todos.find(params[:id])
    end

    def set_global_todo
      @todo = Todo.find(params[:id])
    end

    def new_icon_attachment
      @todo.build_icon
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:title, :iteration_type, :frequency, :daycare_id, tasks_attributes: [:_destroy, :id, :title, :description, :todo_id], icon_attributes: [:id, :attachable_type, :attachable_id, :file]).merge(user_id: current_user.id)
    end

    def set_query
        @query = "%#{params[:query]}%"
    end

    def set_accessible_todos
      @ids = (current_user.global_todos + current_user.local_todos).map(&:id)
    end
end
