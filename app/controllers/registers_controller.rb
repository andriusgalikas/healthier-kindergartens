class RegistersController < ApplicationController
  layout "register"
  def index
    @user = MeetingUser.new
  end

  def create
    @user = MeetingUser.where(email: params[:email]).first
    if @user.nil?
      @user = MeetingUser.new(permit_params)
      @user.token = Devise.friendly_token      
    end

    if @user.save
      send_confirmation_email @user
      redirect_to webinar_calendar_path({ name: @user.name, email: @user.email })
    else
      render text: "Error: #{@user.errors.full_messages.join(", ")}"
    end
  end

  private
    def permit_params
      params.require(:meeting_user).permit(:name, :daycare_name, :mobile, :email)
    end

    def send_confirmation_email user
      #RegistrationMailer.registration_confirmation(user).deliver_later
      host_name = LocaleUrl.find_by(language: I18n.locale.downcase)
      host_url = (host_name.nil?) ? t("mailers.supermanager.url") : host_name.url

      confirm_url = "http://#{host_url}/account_register?token=#{user.token}"
      template = t('mailers.account_registration.content', name: user.name, url: confirm_url)

      RegistrationMailer.registration_confirmation(user, template).deliver_now
    end
end
