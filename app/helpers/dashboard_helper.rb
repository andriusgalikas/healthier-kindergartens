module DashboardHelper

  def notif_per_source_type(notifs, source_type)
    notifs.select{|n| n.source_type == source_type}
  end

  def notif_sender_avatar(notif)
    if notif.source_owner.admin?
      'super-admin.png'
    elsif notif.source_owner.partner?
      notif.source_owner.affiliate.profile_image.file.url
    else
      'logo_menu.png'
    end
  end

end
