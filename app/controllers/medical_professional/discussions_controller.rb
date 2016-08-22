class MedicalProfessional::DiscussionsController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(['medical_professional'])}

  def index
    set_children
    set_child
    set_discussions

  end

  def create
    discussion = Discussion.new(discussion_params.merge(owner_id: current_user.id))
    child = discussion.subject

    if discussion.save!
      discussion.discussion_participants.find_or_create_by(participant: child.parentee)
      discussion.discussion_participants.find_or_create_by(participant: current_user)

      HealthConversationNotificationJob.perform_now(discussion, sender: current_user)
      render discussion
    else
      redirect_to medical_professional_discussions_path, alert: 'There was an error saving the message.'
    end
  end

  private

  def set_children
    @children = current_user.collaborations.map(&:child)
  end

  def set_child
    if params[:child_id].present?
      @active_child = @children.find{|child| child.id == params[:child_id].to_i}
    else
      @active_child = @children.first
    end
  end

  def set_discussions
    @discussions = @active_child.discussions
                   .includes(:discussion_participants, :owner)
                   .select{|disc| disc.owner == current_user ||
                           disc.discussion_participants.object_is_participant?(current_user.department)}
  end

  def discussion_params
    params.require(:discussion).permit(
      :title,
      :content,
      :subject_id,
      :subject_type
    )
  end

end
