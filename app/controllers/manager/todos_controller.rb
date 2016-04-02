class Manager::TodosController < ApplicationController
  before_action -> { authenticate_role!("manager") }

  def new
    @todo = current_user.daycare.local_todos.build
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def todo_params
      params.require(:todo).permit(:title, :iteration_type, :frequency, :daycare_id, :user_id)
    end
end