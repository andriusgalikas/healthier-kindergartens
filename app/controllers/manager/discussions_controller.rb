class Manager::DiscussionsController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(['manager'])}

  def index
    set_department
    set_department_children
    set_child
    set_discussions
  end

  private

  def set_department
    if params[:department_id]
      @active_department = current_user.daycare.departments.detect{|dept| dept.id == params[:department_id].to_i}
    else
      @active_department = current_user.daycare.departments.first
    end
  end

  def set_department_children
    @children = @active_department.children
  end

  def set_child
    if params[:child_id]
      @active_child = @children.detect{|child| child.id == params[:child_id].to_i}
    else
      @active_child = @children.first
    end
  end

  def set_discussions
    @discussions = @active_child.discussions
                   .includes(:discussion_participants, :owner)
                   .select{|disc| disc.owner == current_user ||
                           disc.discussion_participants.any?{|disc_part| current_user.daycare.department_ids.include?(disc_part.participant_id) && disc_part.participant_type == 'Department'}}
  end

end
