class CommentsController < ApplicationController
  layout 'dashboard_v2'

  def create
    set_discussion
    comment = @discussion.comments.build(content: params[:comment][:content], owner_id: current_user.id)

    if comment.save! && request.xhr?
      HealthConversationNotificationJob.perform_now(comment, sender: current_user)
      render partial: 'discussions/comment', locals: {comment: comment}
    else
      redirect_to discussions_path(@discussion)
    end
  end

  private

  def set_discussion
    @discussion = Discussion.find params[:discussion_id]
  end

end
