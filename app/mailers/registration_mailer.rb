class RegistrationMailer < ApplicationMailer
    default template_path: 'mailers/registration'
    
    def send_confirmation user
        @user = user
        mail(to: @user.email, 
            subject: 'Confirm Your Account'
        )
    end
end
