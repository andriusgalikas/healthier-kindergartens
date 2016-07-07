class IllnessesController < ApplicationController
  layout 'dashboard_v2'

  def department_children
    set_children

    render partial: 'child', collection: @children
  end

  private

  def set_children
    department_id = params[:department_id].to_i
    @children ||= current_user.daycare.departments.select{|dpt| dpt.id == department_id}.map(&:children).flatten
  end

end
