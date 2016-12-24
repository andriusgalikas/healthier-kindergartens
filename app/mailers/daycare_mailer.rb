require 'mailin.rb'
class DaycareMailer < ApplicationMailer
    default template_path: 'mailers/daycare'

    def invite (email, message)
        @email = email
	    m = Mailin.new(ENV['SENDINGBLUE_URL'], ENV['SENDINGBLUE_TOKEN'])
#	    puts email
		data = { "to" => {email => "Daycare"},
			"from" => [message.owner.email, message.owner.name],
			"subject" => message.title,
			"html" => message.content
		}
	 
		result = m.send_email(data)
#		puts result
#        mail(to: @email, 
#            subject: "You have been invited to start using Health Childcare"
#        )
    end
end