require 'mailin.rb'
class RegistrationMailer < ApplicationMailer
    default template_path: 'mailers/registration'
    
    def registration_confirmation (user, template)
        @user = user
        confirm_url = "http://#{t('mailers.supermanager.url')}/confirm_email/#{@user.confirm_token}"
	    m = Mailin.new(ENV['SENDINGBLUE_URL'], ENV['SENDINGBLUE_TOKEN'])
		data = { "to" => {@user.email => "Daycare"},
			"from" => [t('mailers.supermanager.email'), t('mailers.supermanager.name')],
			"subject" => t('mailers.mail_confirm.subject'),
			"html" => template
		}	 
		result = m.send_email(data)
    end

    def send_confirmation user
        @user = user
        mail(to: @user.email, 
            subject: 'Confirm Your Account'
        )
    end

    def reset_password_confirmation (user, template)
        @user = user
        m = Mailin.new(ENV['SENDINGBLUE_URL'], ENV['SENDINGBLUE_TOKEN'])
        data = { "to" => {@user.email => "Daycare"},
            "from" => [t('mailers.supermanager.email'), t('mailers.supermanager.name')],
            "subject" => t('mailers.mail_reset_password.subject'),
            "html" => template
        }    
        result = m.send_email(data)
    end

    def register_email_campaign (user, subject, content)
        @user = user
        m = Mailin.new(ENV['SENDINGBLUE_URL'], ENV['SENDINGBLUE_TOKEN'])
        data = { "to" => {@user.email => "Daycare"},
            "from" => [t('mailers.supermanager.email'), t('mailers.supermanager.name')],
            "subject" => subject,
            "html" => content
        }    
        result = m.send_email(data)
    end

    def contact_us_message(user, subject, content)
        m = Mailin.new(ENV['SENDINGBLUE_URL'], ENV['SENDINGBLUE_TOKEN'])
        data = { "to" => {t('mailers.supermanager.email') => "App Manager"},
            "from" => [user, 'User'],
            "subject" => subject,
            "html" => content
        }    
        result = m.send_email(data)
        puts result        
    end
end
