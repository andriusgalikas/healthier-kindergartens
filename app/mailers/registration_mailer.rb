require 'mailin.rb'
class RegistrationMailer < ApplicationMailer
    default template_path: 'mailers/registration'
    
    def registration_confirmation (user, template)
        @user = user
        confirm_url = "#{ENV['BASE_URL']}/confirm_email/#{@user.confirm_token}"
	    m = Mailin.new(ENV['SENDINGBLUE_URL'], ENV['SENDINGBLUE_TOKEN'])
		data = { "to" => {@user.email => "Daycare"},
			"from" => [ENV['SITE_MANAGER_EMAIL'], ENV['SITE_MANAGER_NAME']],
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
            "from" => [ENV['SITE_MANAGER_EMAIL'], ENV['SITE_MANAGER_NAME']],
            "subject" => t('mailers.mail_confirm.subject'),
            "html" => template
        }    
        result = m.send_email(data)
    end

    def register_email_campaign (user, subject, content)
        @user = user
        m = Mailin.new(ENV['SENDINGBLUE_URL'], ENV['SENDINGBLUE_TOKEN'])
        data = { "to" => {@user.email => "Daycare"},
            "from" => [ENV['SITE_MANAGER_EMAIL'], ENV['SITE_MANAGER_NAME']],
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
    end
end
