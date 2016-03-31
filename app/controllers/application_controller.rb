class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    def authenticate_parent!
        unless current_user && current_user.parentee?
            redirect_to root_url
        end
    end

    def authenticate_worker!
        unless current_user && current_user.worker?
            redirect_to root_url
        end
    end

    def authenticate_manager!
        unless current_user && current_user.manager?
            redirect_to root_url
        end
    end

    def authenticate_admin!
        unless current_user && current_user.admin?
            redirect_to root_url
        end
    end
end
