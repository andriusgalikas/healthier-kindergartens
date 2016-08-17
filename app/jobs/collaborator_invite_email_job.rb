class CollaboratorInviteEmailJob < ActiveJob::Base
  queue_as :mailers

  def perform email, inviter
    CollaborationMailer.invite(email, inviter).deliver_later
  end

end
