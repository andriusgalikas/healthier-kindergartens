require 'mailin.rb'
class DaycareInviteMailer < ApplicationMailer
    default template_path: 'mailers/daycare'

    def invite (email, subject, content, from_email, from_name)
	    m = Mailin.new(ENV['SENDINGBLUE_URL'], ENV['SENDINGBLUE_TOKEN'])
		data = { "to" => {email => "Daycare"},
			"from" => [from_email, from_name],
			"subject" => subject,
			"html" => content
		}
	 
		result = m.send_email(data)
    end
end