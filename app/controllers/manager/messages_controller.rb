class Manager::MessagesController < ApplicationController
  layout 'message'
  before_action -> { authenticate_role!(['manager'])}

  def subject
    set_subjects
  end

  def sub_subject
    set_subject
    set_sub_subjects
  end

  def content
    find_message_template

    if @message_template
      @message = Message.new

      render :new
    else
      redirect_to manager_messages_path, notice: 'No corresponding template found.'
    end
  end

  def create
    @message = Message.new(message_params.merge(owner_id: current_user.id))

    if @message.save
      MessageNotificationJob.perform_now(@message)
      notice = 'Message successfully sent.'
    else
      notice = 'There was an error creating the message.'
    end

    redirect_to manager_messages_path, notice: notice
  end

  private

  def set_subjects
    @subjects ||= MessageSubject.main_subjects
  end

  def set_subject
    @subject = MessageSubject.find params[:subject_id] if (params[:subject_id].present?)
  end

  def set_sub_subjects
    @sub_subjects = @subject.sub_subjects if @subject.present?
  end

  def set_sub_subject
    @sub_subject = @subject.sub_subjects.find(params[:sub_subject_id]) if @subject && params[:sub_subject_id]
  end

  def find_message_template
    set_subject
    set_sub_subject

    if @subject && @sub_subject && params[:target_role].present?
      @message_template = @sub_subject.message_templates.for_role params[:target_role]
    end
  end

  def message_params
    params.require(:message).permit(
      :message_template_id,
      :target_role,
      :title,
      :content
    )
  end

end
