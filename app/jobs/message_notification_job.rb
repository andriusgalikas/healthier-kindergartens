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
    recipients = []
    sender = message.owner

    if sender.admin?
      recipients += User.send(message.target_role)
    elsif sender.manager?
      recipients += sender.daycare.parents if message.for_parentee?
      recipients += sender.daycare.workers if message.for_worker?
    elsif sender.partner?
      recipients += User.parentee if message.for_parentee?
      recipients += User.worker if message.for_worker?
      recipients += User.manager if message.for_manager?
    end

    recipients
  end

end
