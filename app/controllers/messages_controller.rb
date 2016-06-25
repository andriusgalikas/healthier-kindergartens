class MessagesController < ApplicationController
  layout 'message'

  def list
    params[:page] ||= 1
    get_all_main_subjects if current_user.manager?
    set_notification_message
    set_messages

    if request.xhr?
      render partial: '/messages/message_list'
    else
      render '/messages/list'
    end
  end

  private

  def get_all_main_subjects
    @subjects = MessageSubject.main_subjects
  end

  def set_notification_message
    if params[:notification_id].present?
      @notification = Notification.find(params[:notification_id])
      @notification.archived!
    end
  end

  def set_subject
    @subject = MessageSubject.find params[:subject_id] if (params[:subject_id].present?)
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

    if params['list_type'] == 'sent'  # set sender filter
      cond_str << 'owner_id = ?'
      cond_arr << current_user.id

      if params['target_role']
        cond_str << '? = ANY (target_roles)'
        cond_arr << params['target_role']
      end
    else   # set receiver filter
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

    # set message template filter, if present
    if @message_template.present?
      cond_str << 'message_template_id = ?'
      cond_arr << @message_template.id
    end

    [cond_str.join(' AND '), cond_arr]
  end

end
