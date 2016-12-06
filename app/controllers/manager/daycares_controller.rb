class Manager::DaycaresController < ApplicationController
  layout 'registration'
  before_action -> { authenticate_role!(["manager"]) }

  def invite
    @message = Message.new(owner_id: current_user.id)
  end

  def send_invites      
    @message = Message.new(message_params.merge(owner_id: current_user.id))

    if @message.save
      MessageNotificationJob.perform_now(@message, {:invitation => true})
      DaycareInviteEmailJob.perform_now(@message, {:invitation => true})
      redirect_to dashboard_url, notice: "Successfully sent your invites"
    else
      render "invite"
    end

    #DaycareInviteEmailJob.perform_later(params[:emails].join(','))
    #redirect_to dashboard_url, notice: "Successfully sent your invites"
  end

  private

  def message_params
    params.require(:message).permit(
      :title,
      :content,
      target_roles: []
    )
  end
end