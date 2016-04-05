class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
        render "dashboard/#{current_user.role}", format: [:html]
    rescue ActionView::MissingTemplate
        redirect_to current_user.admin? ? admin_root_url : root_url
    end
end