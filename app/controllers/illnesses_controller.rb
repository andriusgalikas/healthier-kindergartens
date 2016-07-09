class IllnessesController < ApplicationController
  layout 'dashboard_v2'

  def department_children
    set_children

    #    render partial: 'child', collection: @children
    render json: @children.inject([]){|list, child| list << {id: child.id, name: child.name}; list}
  end

  def child_profile
    set_child

    render partial: 'child_profile'
  end

  def symptoms
    set_illness
    set_symptoms

    render partial: 'symptoms'
  end

  def department_workers
    set_department
    set_workers

    render partial: 'worker_names'
  end

  def worker_profile
    set_worker

    render partial: 'worker_profile'
  end

  def create_child_record
    redirect_to illnesses_path
  end

  def create_department_record
    redirect_to illnesses_path
  end

  private

  def set_children
    department_id = params[:department_id].to_i
    @children ||= current_user.daycare.departments.select{|dpt| dpt.id == department_id}.map(&:children).flatten
  end

  def set_child
    @child ||= Child.find(params[:child_id])
  end

  def set_illness
    @illness ||= ILLNESSES[params[:illness_code]]
  end

  def set_symptoms
    @symptoms ||= @illness[:symptoms].inject({}) {|list, symp| list[symp] = SYMPTOMS[symp]; list}
  end

  def set_department
    @department ||= Department.find params[:department_id]
  end

  def set_workers
    @workers ||= @department.workers
  end

  def set_worker
    @worker ||= User.find params[:worker_id]
  end

end
