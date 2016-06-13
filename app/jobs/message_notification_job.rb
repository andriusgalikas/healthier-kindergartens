class MessageNotificationJob < ActiveJob::Base
  queue_as :notification

  def perform message
    target_users = User.send(message.target_role)

    target_users.each do |user|
      notif = message.notifications.build(target_id: user.id)
      if notif.save!
        NotificationMailer.notify(notif, message.owner).deliver_later
      end
    end
  end


end
