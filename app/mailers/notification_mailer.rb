class NotificationMailer < ApplicationMailer
  default template_path: 'mailers/message_notification'

  def notify notification, sender
    @email = notification.target.email

    mail(to: @email,
         subject: "You have a new notification from #{sender.name}"
        )
  end

end
