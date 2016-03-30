class Admin::UsersController < AdminController

    def index
        set_users
    end

    private

    def set_users
        @users ||= User.all
    end
end