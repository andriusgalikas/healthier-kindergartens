class MessageNotificationJob < ActiveJob::Base
  queue_as :notification

  def perform(message, opts={})
    if opts[:invitation] == true
      target_users = get_target_all_users(message, opts)
    else
      target_users = get_target_users(message, opts)
    end

    target_users.each do |user|
      notif = message.notifications.build(target_id: user.id)
      if notif.save!
        NotificationMailer.notify(notif, message.owner, message.content).deliver_later
      end
    end
  end

  private

  def get_target_users(message, opts)
    recipients = []
    sender = message.owner

    if sender.admin? || sender.partner?
      recipients += User.parentee if message.for_parentee?
      recipients += User.worker if message.for_worker?
      recipients += User.manager if message.for_manager?
    elsif sender.manager?
      recipients += sender.daycare.workers if message.for_worker?
      if opts[:target_department]
        dept_id = opts[:target_department].to_i
        recipients = recipients.select{|rec| rec.department_id == dept_id}
      end

      recipients += sender.daycare.parents if message.for_parentee?

    elsif sender.worker?
      recipients += sender.daycare.parents if message.for_parentee?
    end

    recipients
  end

  def get_target_all_users(message, opts)
    recipients = []
    sender = message.owner

    recipients += User.parentee if message.for_parentee?
    recipients += User.worker if message.for_worker?
    recipients += User.manager if message.for_manager?

    recipients
  end

end
