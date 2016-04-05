class DaycareInviteEmailJob < ActiveJob::Base
    queue_as :mailers

    def perform emails
        emails.each do |email|
            DaycareMailer.invite(email).deliver_later
        end
    end
end