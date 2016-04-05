class DaycareMailer < ApplicationController

    def invite email
        mail(to: email, subject: "You have been invited to start using Health Childcare")
    end
end