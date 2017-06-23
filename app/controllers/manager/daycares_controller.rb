class Manager::DaycaresController < ApplicationController
  layout 'registration'
  before_action -> { authenticate_role!(["manager"]) }

  def invite_survey
    @daycare_role = params[:type]

    @subject = MessageSubject.find_or_create_by(title: ENV['SURVEY_TEMPLATE_SUBJECT'], language: I18n.locale.downcase) 
    template_key = 'SURVEY_TEMPLATE_SUBJECT_' + @daycare_role.upcase
    @sub_subject = @subject.sub_subjects.find_or_create_by(title: ENV[template_key], language: I18n.locale.downcase)
    @message_template = @sub_subject.message_templates.find_by(target_role: MessageTemplate.target_roles[@daycare_role.downcase], language: I18n.locale.downcase)
  end
  
  def invite
    @message = Message.new(owner_id: current_user.id)
  end

  def send_invite_survey    
    ManagerInviteEmailJob.perform_now(params[:email], params[:title], params[:content], current_user.email, current_user.name)
    redirect_to results_manager_subjects_path, notice: "Successfully sent your invites"
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