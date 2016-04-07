class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    def authenticate_role! roles
        if current_user.nil?
            redirect_to new_user_session_url
        elsif current_user && !(roles.include?(current_user.role))
            redirect_to dashboard_url
        end
    end 

    def subscribed_manager!
      unless current_user && current_user.manager? && current_user.subscribed?
        redirect_to dashboard_url, alert: "You need to upgrade in order to access this feature."
      end
    end

    def after_sign_in_path_for resource
        resource.admin? ? admin_root_path : dashboard_path
    end

    def after_sign_up_path_for resource
        if resource.admin? 
            admin_root_path
        elsif resource.manager?
            invite_manager_daycares_path
        else
            dashboard_path
        end
    end
end
