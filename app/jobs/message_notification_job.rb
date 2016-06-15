class MessageNotificationJob < ActiveJob::Base
  queue_as :notification

  def perform message
    target_users = get_target_users(message)

    target_users.each do |user|
      notif = message.notifications.build(target_id: user.id)
      if notif.save!
        NotificationMailer.notify(notif, message.owner).deliver_later
      end
    end
  end


  private

  def get_target_users(message)
    sender = message.owner

    if sender.admin?
      User.send(message.target_role)
    elsif sender.manager?
      message.for_parentee? ? sender.daycare.parents : sender.daycare.workers
    end
  end

end
