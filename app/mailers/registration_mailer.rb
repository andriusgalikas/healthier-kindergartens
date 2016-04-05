class RegistrationMailer < ApplicationMailer
    
    def send_confirmation user
        @user = user
        mail(to: @user.email, subject: 'Confirm Your Account')
    end
end
