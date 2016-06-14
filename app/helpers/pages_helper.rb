module PagesHelper

  def current_user_role_avatar
    if current_user.manager?
      'manager.png'
    elsif current_user.parentee?
      'parent.png'
    elsif current_user.worker?
      'worker.png'
    else
      'logo_menu.png'
    end
  end

  def vote_question
    if ['manager', 'parentee', 'worker'].include?(current_user.role)
      I18n.t("votes.#{current_user.role}.question")
    else
      ''
    end
  end

  def vote_invitation
    invitation = []

    if current_user.manager?
      invitation << content_tag(:p, I18n.t('votes.manager.invitation')) unless current_user.subscribed?
      invitation << content_tag(:p, I18n.t('votes.manager.demand'))
    elsif ['parentee', 'worker'].include?(current_user.role)
      invitation << content_tag(:p, I18n.t("votes.#{current_user.role}.invitation"))

      if current_user.voted_for?('hcc')
        invitation << content_tag(:p, I18n.t("votes.#{current_user.role}.thank_you"))
      else
        invitation << content_tag(:p, I18n.t("votes.#{current_user.role}.demand_1"))
        invitation << content_tag(:span, I18n.t("votes.#{current_user.role}.demand_2"))
        invitation << content_tag(:a, I18n.t('votes.vote'), href: cast_vote_path(vote_candidate_code: 'hcc'), class: 'btn btn-success', id: 'vote-btn')
      end
    end

    invitation.join('')
  end

  def vote_results(role)
    if role == 'parentee'
      current_user.daycare.parents.select{|p| p.voted_for?('hcc')}.size
    elsif role == 'worker'
      current_user.daycare.workers.select{|p| p.voted_for?('hcc')}.size
    end
  end

end
