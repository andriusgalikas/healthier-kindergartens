class DiscussionsController < ApplicationController
  layout 'dashboard_v2'

  def index
    if current_user.parentee?
      set_discussions
      set_parents_child
      set_discussion
    elsif current_user.worker?
      set_department
      set_department_children
      set_department_child
      set_discussions
      set_discussion
    end

    archive_notification
  end

  def show
    set_discussion
    set_selected_child
  end

  private

  def set_discussions
    if current_user.parentee?
      @discussions = current_user.children
                     .collect{|child| child.discussions.includes({comments: :owner}, :owner)}
                     .flatten
    elsif current_user.worker?
      @discussions = DiscussionParticipant.where(participant_id: current_user.daycare.department_ids, participant_type: 'Department')
                     .map(&:discussion)
                     .flatten
                     .select{|disc| disc.subject == @active_child}
    else
      @discussions = []
    end
  end

  def set_discussion
    if params[:id]
      @discussion = Discussion.find params[:id]
    elsif @discussions.present?
      @discussion = @discussions.last
    else
      @discussion = Discussion.create(title: @active_child.name, subject: @active_child, owner_id: current_user.id)
      @discussion.discussion_participants.create(participant: @active_child.department)
      @discussion.discussion_participants.create(participant: @active_child.parentee)
    end
  end

  def set_parents_child
    if params[:child_id]
      @active_child = current_user.children.where(id: params[:child_id])
    else
      @active_child = current_user.children.first
    end
  end

  def set_department
    if params[:department_id]
      @active_department = current_user.daycare.departments.where(id: params[:department_id]).first
    else
      @active_department = current_user.daycare.departments.first
    end
  end

  def set_department_children
    @children = @active_department.children
  end

  def set_department_child
    if params[:child_id]
      @active_child = @children.select{|child| child.id == params[:child_id].to_i}.first
    else
      @active_child = @children.first
    end
  end

end
