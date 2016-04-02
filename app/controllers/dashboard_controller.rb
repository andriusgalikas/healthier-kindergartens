class DashboardController < ApplicationController
    before_action :authenticate_user!

    def index
        render "dashboard/#{current_user.role}", format: [:html]
    # rescue
        # redirect_to admin_root_url
    end
end