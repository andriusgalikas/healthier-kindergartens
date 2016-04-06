module HasMailchimp
    extend ActiveSupport::Concern

    included do
        after_create :unsubscribe_from_list
    end

    def unsubscribe_from_list
        Gibbon::Request.lists(Rails.application.secrets.mailchimp_cold_email_list_id).members(lower_case_md5_hashed_email_address).update(body: { status: 'unsubscribed'} )
    rescue Gibbon::MailChimpError => e
        logger.error "Mailchimp error while unsubscribing customer: #{e.detail}" unless e.body['status'] == 404
        true
    end

    private

    def lower_case_md5_hashed_email_address
        Digest::MD5.hexdigest(email)
    end
end