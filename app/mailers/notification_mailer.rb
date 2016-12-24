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
#	puts result

  end

end
