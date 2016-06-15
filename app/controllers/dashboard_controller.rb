class DashboardController < ApplicationController
    layout 'dashboard'
    before_action :authenticate_subscribed!
    before_action :set_notifications

    def index
      render "dashboard/#{current_user.role}", format: [:html]
      rescue ActionView::MissingTemplate
        redirect_to current_user.admin? ? admin_root_url : root_url
    end

    private

    def set_notifications
      @notifications ||= current_user.notifications.unread
    end
end
