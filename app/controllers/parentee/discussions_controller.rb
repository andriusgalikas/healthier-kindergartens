class Parentee::DiscussionsController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(["parentee"]) }

  def index
    set_child
    set_discussions

    archive_notification
  end

  def create
    discussion = Discussion.new(discussion_params.merge(owner_id: current_user.id))
    child = discussion.subject

    if discussion.save!
      discussion.discussion_participants.create(participant: child.parentee)
      discussion.discussion_participants.create(participant: child.department)
      child.collaborators.find_or_create_by(collaborator: child.department)

      HealthConversationNotificationJob.perform_now(discussion, sender: current_user)
      render discussion
    else
      redirect_to parentee_discussions_path
    end
  end

  def invite_doctor
    invite = CollaborationInvite.new(invite_params.merge(inviter_id: current_user.id))

    if invite.save
      CollaboratorInviteEmailJob.perform_later(params[:email], current_user.name)

      render partial: 'pending_invite', locals: {email: params[:collaboration_invite][:invitee_email]}
    else
      redirect_to parentee_discussions_path
    end
  end

  private

  def set_child
    if params[:child_id]
      @active_child = current_user.children.detect{|child| child.id == params[:child_id].to_i}
    else
      @active_child = current_user.children.first
    end
  end

  def set_discussions
    @discussions = @active_child.discussions.includes(:owner)
  end

  def discussion_params
    params.require(:discussion).permit(
      :title,
      :content,
      :subject_id,
      :subject_type
    )
  end

  def invite_params
    params.require(:collaboration_invite).permit(
      :child_id,
      :invitee_email
    )
  end

end
