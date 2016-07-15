class IllnessesController < ApplicationController
  layout 'dashboard_v2'

  def department_children
    set_children

    render partial: 'choose_child'
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
    filtered_params = child_illness_record_params

    status = IllnessRecorder.new(child_illness_record_params).save_child_illness!
    if status[:code] == 'ok'
      redirect_to illnesses_path, notice: status[:message]
    else
      render 'new_child_record', danger: status[:message]
    end
  end

  def create_department_record
    filtered_params = department_illness_record_params
    puts filtered_params.inspect

    status = IllnessRecorder.new(department_illness_record_params).save_department_illness!
    if status[:code] == 'ok'
      redirect_to illnesses_path, notice: status[:message]
    else
      render 'new_department_record', danger: status[:message]
    end
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

  def child_illness_record_params
    params.permit(
      child: [
        :id
      ],
      record: [
        :illness_code,
        :symptoms_description,
        :start_date,
        :end_date,
        :possible_trigger,
        :extra_details,
        :contact_parent_message,
        :contact_parent_reason,
        :contact_doctor_message,
        :contact_doctor_reason,
        :additional_actions,
        symptom_codes: []
      ],
      worker: [
        :id,
        :password
      ]
    )
  end

  def department_illness_record_params
    params.permit(
      department: [:id],
      record: [
        :sick_workers_count,
        :sick_children_count,
        :start_date,
        :end_date,
        :possible_trigger,
        :extra_details,
        :additional_actions
      ],
      worker: [
        :id,
        :password
      ]
    )
  end

end
