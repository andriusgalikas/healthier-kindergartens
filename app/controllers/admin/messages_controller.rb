class Admin::MessagesController < AdminController
  layout 'message'

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

  def sent_messages
    @messages = set_messages

    if request.xhr?
      render partial: 'message_list'
    end
  end

  private

  def message_params
    params.require(:message).permit(
      :target_role,
      :title,
      :content
    )
  end

  def set_messages
    cond_str, cond_arr = set_query_conditions

    @messsages ||= if params[:page].present?
                     Message.by_owner(current_user.id)
                       .where(cond_str, *cond_arr)
                       .order(created_at: :asc)
                       .page(params[:page])
                   else
                     Message.by_owner(current_user.id)
                       .where(cond_str, *cond_arr)
                       .order(created_at: :asc)
                       .page(1)
                   end
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
      cond_str << 'target_role = ?'
      cond_arr << Message.target_roles[params['target_role']]
    end

    [cond_str.join(' AND '), cond_arr]
  end

end
