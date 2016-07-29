class SubTaskCompletesController < ApplicationController
  before_action -> { authenticate_role!(['parentee', 'worker'])}
  before_action :authenticate_subscribed!

  def update
    set_sub_task_complete
    set_task_complete
    update_sub_task_to_pass
    redirect_to todo_todo_complete_url(@task_complete.todo_task.todo, @task_complete.todo_complete), notice: 'Successfully marked sub-task as completed.'
  end

  private

  def set_sub_task_complete
    @sub_task_complete = current_user.sub_task_completes.find(params[:id])
  end

  def set_task_complete
    @task_complete = @sub_task_complete.todo_task_complete
  end

  def update_sub_task_to_pass
    @sub_task_complete.update(completion_date: Time.now, result: 1)
  end


end
