class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    def authenticate_role! role
        if current_user.nil?
            redirect_to new_user_session_url
        elsif current_user && !(current_user.role == role)
            redirect_to dashboard_url
        end
    end 

    def after_sign_in_path_for resource
        resource.admin? ? admin_root_path : dashboard_path
    end

    def after_sign_up_path_for resource
        resource.admin? ? admin_root_path : dashboard_path
    end
end
