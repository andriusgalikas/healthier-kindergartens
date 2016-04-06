class DaycareMailer < ApplicationMailer
    default template_path: 'mailers/daycare'

    def invite email
        @email = email
        mail(to: @email, 
            subject: "You have been invited to start using Health Childcare"
        )
    end
end