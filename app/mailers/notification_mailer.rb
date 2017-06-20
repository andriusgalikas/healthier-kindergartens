require 'mailin.rb'
class NotificationMailer < ApplicationMailer
  default template_path: 'mailers/message_notification'

  def notify notification, sender, content
    @email = notification.target.email
    m = Mailin.new(ENV['SENDINGBLUE_URL'], ENV['SENDINGBLUE_TOKEN'])
#    puts notification.target.email
	data = { "to" => {notification.target.email => notification.target.name},
		"from" => [sender.email, sender.name],
		"subject" => "You have a new notification from #{sender.name}",
		"html" => content
	}
 
	result = m.send_email(data)

  end

    def plan_confirmation (user, template, attachment)
        @user = user
	    m = Mailin.new(ENV['SENDINGBLUE_URL'], ENV['SENDINGBLUE_TOKEN'])
		data = { "to" => {@user.email => "Daycare"},
			"from" => [t('mailers.supermanager.email'), t('mailers.supermanager.name')],
			"subject" => t('mailers.plan_confirm.subject'),
			"html" => template,
			"attachment" => attachment
		}	 
		result = m.send_email(data)
    end

end
