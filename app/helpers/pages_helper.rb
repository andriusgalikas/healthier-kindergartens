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

  def vote_invitation
    invitation = []

    if current_user.manager?
      invitation << content_tag(:p, "Want to keep the children and staff under your care from harm's way and fullfil your ethical and professional obligation? Join us to eliminate the factors that spread ongoing infections and absenteeism which can drain your childcare facility's productivity.") unless current_user.subscribed?

      invitation << content_tag(:p, "CONTRIBUTE TO THE HEALTH AND HAPPINESS OF CHILDREN AND EMPLOYEES UNDER YOUR CARE AND SUPERVISION TODAY.")
    elsif current_user.parentee?
      invitation << content_tag(:p, "Studies had proven that children cared for in a childcare facility are 300% more vulnerable to infections than children cared for at home. Though most illnesses get resolved without disrupting the child's development, some infections can cause lasting physical damage to the child such as cognitive disabilities which affect future learning.")

      if current_user.voted_for?('hcc')
        invitation << content_tag(:p, "THANK YOU FOR SUPPORTING THE CAUSE OF BETTER PROTECTION FOR YOUR CHILDREN'S HEALTH AND LEARNING CAPABILITIES THROUGH HEALTH PRESERVING CARE PROGRAM.")
      else
        invitation << content_tag(:p, "DEMAND PROTECTION FOR YOUR CHILDREN'S HEALTH AND LEARNING CAPABILITIES TODAY. VOTE FOR HEALTH PRESERVING CARE PROGRAM.")
        invitation << content_tag(:span, "Vote for Health Preserving Care Program.")
        invitation << content_tag(:a, 'Vote', href: cast_vote_path(vote_candidate_code: 'hcc'), class: 'btn btn-success', id: 'vote-btn')
      end
    elsif current_user.worker?
      invitation << content_tag(:p, "The risk of infection in a childcare facility does not spare the workers. Studies had proven that a large proportion of daycare staff is women in their childbearing age. During their gestation period, their body's immune system undergoes several changes that results to a weak immune system. This increases the chances of getting infection both to the mothers and children.")

      if current_user.voted_for?('hcc')
        invitation << content_tag(:p, "THANK YOU FOR SUPPORTING THE CAUSE OF BETTER PROTECTION AGAINTS ON-GOING RISK OF INFECTION AND RISK TO YOUR HEALTH THROUGH HEALTH PRESERVING CARE PROGRAM.")
      else
        invitation << content_tag(:p, "DEMAND BETTER PROTECTION AGAINST THE ON-GOING RISK OF INFECTION THAT CAN PUT YOUR HEALTH AT RISK. VOTE FOR HEALTH PRESERVING CARE PROGRAM TODAY.")
        invitation << content_tag(:span, "Vote for Health Preserving Care Program.")
        invitation << content_tag(:a, 'Vote', href: cast_vote_path(vote_candidate_code: 'hcc'), class: 'btn btn-success', id: 'vote-btn')
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
