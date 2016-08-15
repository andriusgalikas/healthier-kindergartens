module DiscussionsHelper

  def daycare_logo(daycare)
    if daycare.profile_image.present?
      daycare.profile_image.file.url
    else
      'childcare-logo-04.png'
    end
  end

end
