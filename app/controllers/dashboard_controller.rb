class DashboardController < ApplicationController
    layout 'dashboard'
    before_action :authenticate_subscribed!
    before_action :set_notifications

    def index
      get_permission

      render "dashboard/#{current_user.role}", format: [:html]
      rescue ActionView::MissingTemplate
        redirect_to current_user.admin? ? admin_root_url : root_url
    end

    private

    def set_notifications
      @notifications ||= current_user.notifications.unread
      @notifications_by_sender ||= Notification.count_by_owner(current_user.id)
    end

    def get_permission
      group = 0
      sub_type = 0
      case current_user.role
      when 'manager'
        group = 0
        sub_type = current_user.daycare.care_type + 1
      when 'worker'
        group = 1
        sub_type = current_user.daycare.care_type + 1
      when 'parentee'
        group = 2
        sub_type = current_user.daycare.care_type + 1
      when 'partner'
        group = 3
        sub_type = 0
      end
      puts group, sub_type
      @permissions = Permission.where(member_type: group, sub_type: sub_type).order(:feature)
    end
end
