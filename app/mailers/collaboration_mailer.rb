class CollaborationMailer < ApplicationMailer
  default template_path: 'mailers/collaboration'

  def invite email, inviter
    @email = email
    @inviter = inviter
    mail(to: @email,
         subject: 'You have been invited to collaborate on a child using Health Childcare',
         inviter: inviter
        )
  end
end
