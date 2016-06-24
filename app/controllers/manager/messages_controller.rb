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

  def list
    params[:page] ||= 1
    get_all_main_subjects
    set_notification_message
    set_messages

    if request.xhr?
      render partial: '/messages/message_list'
    end
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
    @sub_subject = @subject.sub_subjects.find(params[:sub_subject_id]) if @subject && params[:sub_subject_id].present?
  end

  def find_message_template
    set_subject
    set_sub_subject

    if @subject && @sub_subject && params['target_role'].present?
      @message_template = @sub_subject.message_templates.for_role params['target_role']
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

  def get_all_main_subjects
    @subjects = MessageSubject.main_subjects
  end

  def set_messages
    find_message_template

    cond_str, cond_arr = set_query_conditions

    @messages ||= Message.where(cond_str, *cond_arr)
                .order(created_at: :desc)
                .page(params[:page])
  end

  def set_query_conditions
    cond_str = []
    cond_arr = []

    if params['list_type'] == 'sent'
      cond_str << 'owner_id = ?'
      cond_arr << current_user.id

      if params['target_role']
        cond_str << '? = ANY (target_roles)'
        cond_arr << params['target_role']
      end
    else
      notifs = current_user.notifications.by_source_type('Message')
      msg_ids = if params['target_role'].present?
                  notifs.map(&:source)
                    .select{|msg_source| msg_source.owner.role == params['target_role']}
                    .map(&:id)
                else
                  notifs.map(&:source)
                    .map(&:id)
                end

      msg_ids = msg_ids.reject{|msg_id| msg_id == @notification.source_id} if @notification.present?

      cond_str << 'id IN (?)'
      cond_arr << msg_ids
    end

    if @message_template.present?
      cond_str << 'message_template_id = ?'
      cond_arr << @message_template.id
    end

    if params['start_date'].present?
      cond_str << 'created_at > ?'
      cond_arr << Date.parse(params['start_date'])
    end

    if params['end_date'].present?
      cond_str << 'created_at < ?'
      cond_arr << Date.parse(params['end_date'])
    end

    [cond_str.join(' AND '), cond_arr]
  end

  def set_notification_message
    if params[:notification_id].present?
      @notification = Notification.find(params[:notification_id])
      @notification.archived!
    end
  end

end
