module DashboardHelper

  def notif_per_source_type(notifs, source_type)
    notifs.select{|n| n.source_type == source_type}
  end

  def notif_sender_avatar(notif)
    sender = notif.source_owner

    if sender.admin?
      'super-admin.png'
    elsif sender.partner?
      notif.source_owner.affiliate.profile_image.file.url
    elsif sender.manager?
      'manager.png'
    elsif sender.parentee?
      'parent.png'
    elsif sender.worker?
      'worker.png'
    else
      'logo_menu.png'
    end
  end

end
