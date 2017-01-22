class Admin::UsersController < AdminController

    def index
        @users ||= User.all
        @users = @users.name_like(params[:name]) unless params[:name].nil?
        @users = @users.email_like(params[:email]) unless params[:email].nil?
        @users = @users.by_role(params[:role]) unless params[:role].nil?
        @users = @users.daycare_like(params[:daycare_name]) unless params[:daycare_name].nil?
        @users = @users.by_daycare(params[:daycare_id]) unless params[:daycare_id].nil?
        @users = @users.department_like(params[:department_name]) unless params[:department_name].nil? || params[:department_name].blank?
    end

    def destroy
	    @user = User.find(params[:id])
	    @user.destroy

	    redirect_to admin_users_path, notice: "User deleted."
    end

    private

    def set_users
        @users ||= User.all
    end
end