class RegistersController < ApplicationController
  layout "register"
  def index
    @user = User.new
  end

  def create
    @user = User.new(permit_params)
    @user.password = @user.password_confirmation = @user.default_password_token = Devise.friendly_token.first(8)
    if @user.save
      send_confirmation_email @user
      redirect_to webinar_calendar_path({ name: @user.name, email: @user.email })
    else
      render text: "Error: #{@user.errors.full_messages.join(", ")}"
    end
  end

  private
    def permit_params
      params.require(:user).permit(:name, :daycare_name, :mobile, :email, :password, :password_confirmation)
    end

    def send_confirmation_email user
      RegistrationMailer.send_confirmation(user).deliver_now
    end

end
