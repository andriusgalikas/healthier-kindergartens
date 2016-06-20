class Partner::MessagesController < ApplicationController
  layout 'message'
  before_action -> { authenticate_role!(['partner'])}

  def new
    @message = Message.new
  end

  def list
    @messages = set_messages

    if request.xhr?
      render partial: 'message_list'
    end
  end

  private

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
