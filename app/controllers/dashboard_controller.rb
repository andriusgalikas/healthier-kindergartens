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
      daycare_id = 0
      case current_user.role
      when 'manager'
        group = 0
        sub_type = current_user.daycare.care_type + 1
        daycare_id = current_user.daycare.id
      when 'worker'
        group = 1
        if current_user.daycare.nil?
          sub_type = current_user.affiliate.affiliate_type
          daycare_id = current_user.affiliate.id
        else
          sub_type = current_user.daycare.care_type + 1
          daycare_id = current_user.daycare.id
        end
      when 'parentee'
        group = 2
        sub_type = current_user.daycare.care_type + 1
        daycare_id = current_user.daycare.id
      when 'partner'
        group = 3
        sub_type = current_user.affiliate.affiliate_type
        daycare_id = current_user.affiliate.id
      end

      unless current_user.daycare.nil?
        @permissions = Permission.where(member_type: group, sub_type: sub_type, daycare_id: daycare_id).order(:feature)
        if @permissions.blank?
          @permissions = Permission.where(member_type: group, sub_type: sub_type, daycare_id: 0).order(:feature)
        end
      else
        @permissions = Permission.where(member_type: group, sub_type: sub_type, partner_id: daycare_id).order(:feature)
        if @permissions.blank?
          @permissions = Permission.where(member_type: group, sub_type: sub_type, partner_id: 0).order(:feature)
        end

        puts @permissions.length, group, sub_type
      end
    end
end
