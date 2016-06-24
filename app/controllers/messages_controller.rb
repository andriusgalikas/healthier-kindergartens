class MessagesController < ApplicationController
  layout 'messages'

  def list
    params[:page] ||= 1
    set_notification_message
    set_messages

    if request.xhr?
      render partial: '/messages/message_list'
    end
  end

  private

  def set_notification_message
    if params[:notification_id].present?
      @notification = Notification.find(params[:notification_id])
      @notification.archived!
    end
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

    # set start_date filter
    if params['start_date'].present?
      cond_str << 'created_at > ?'
      cond_arr << Date.parse(params['start_date'])
    end

    # set end_date filter
    if params['end_date'].present?
      cond_str << 'created_at < ? '
      cond_arr << Date.parse(params['end_date'])
    end

    # set sender filter
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

    [cond_str.join(' AND '), cond_arr]
  end

end
