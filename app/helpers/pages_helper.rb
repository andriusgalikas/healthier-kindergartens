module PagesHelper

  def current_user_role_avatar
    role_avatar current_user.role
  end

  def role_avatar role
    if role == 'manager'
      'manager.png'
    elsif role == 'parentee'
      'parent.png'
    elsif role == 'worker'
      'worker.png'
    else
      'logo_menu.png'
    end
  end

  def vote_question
    if current_user.manager?
      'How many parents and workers want this?'
    elsif current_user.parentee? || current_user.worker?
      'How many of your fellow colleagues want this?'
    else
      ''
    end
  end

end
