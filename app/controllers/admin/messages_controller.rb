class Admin::MessagesController < AdminController
  layout 'message'

  def list
    params[:page] ||= 1
    @messages = set_messages

    if request.xhr?
      render partial: '/messages/message_list'
    else
      render '/messages/list'
    end
  end

  def new
    @message = Message.new(owner_id: current_user.id)
  end

  def create
    @message = Message.new(message_params.merge(owner_id: current_user.id))

    if @message.save
      MessageNotificationJob.perform_now(@message)
      redirect_to admin_message_templates_path, notice: 'Message successfully sent.'
    else
      redirect_to new_admin_message_template_path, notice: 'There was an error creating the message.'
    end
  end

  private

  def message_params
    params.require(:message).permit(
      :title,
      :content,
      target_roles: []
    )
  end

  def set_messages
    cond_str, cond_arr = set_query_conditions

    @messsages ||= Message.by_owner(current_user.id)
                 .where(cond_str, *cond_arr)
                 .order(created_at: :asc)
                 .page(params[:page])
  end

  def set_query_conditions
    cond_str = []
    cond_arr = []

    if params['start_date'].present?
      cond_str << 'created_at > ?'
      cond_arr << Date.parse(params['start_date'])
    end

    if params['end_date'].present?
      cond_str << 'created_at < ? '
      cond_arr << Date.parse(params['end_date'])
    end

    if params['target_role'].present?
      cond_str << '? = ANY (target_roles)'
      cond_arr << params['target_role']
    end

    [cond_str.join(' AND '), cond_arr]
  end

end
