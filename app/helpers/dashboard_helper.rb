module DashboardHelper

  def notif_per_source_type(notifs, source_type)
    notifs.select{|n| n.source_type == source_type}
  end

  def notif_sender_avatar(notif)
    sender = notif.source_owner

    if sender.admin?
      'super-admin.png'
    elsif sender.partner?
      sender.affiliate.profile_image.file.url
    elsif sender.manager?
      'manager.png'
    elsif sender.parentee?
      'parent.png'
    elsif sender.worker?
      notif.source.kind_of?(Message) ? 'worker.png' : 'childcare-logo-04.png'
    else
      'logo_menu.png'
    end
  end

  def notif_sender_name(notif)
    if ['Discussion', 'Comment'].include?(notif.source_type) && notif.source_owner.worker?
      notif.source_owner.department.name
    else
      notif.source_owner.name
    end
  end

end
