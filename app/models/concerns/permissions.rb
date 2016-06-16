module Permissions
  extend ActiveSupport::Concern

  MESSAGE_PERMISSION_HASH = {
    'admin'   => ['parentee', 'worker', 'manager'],
    'manager' => ['parentee', 'worker'],
    'partner' => ['parentee', 'worker', 'manager']
  }

  included do


    def self.allowed_recipients_for_role(role)
      MESSAGE_PERMISSION_HASH[role]
    end

    def self.allowed_senders_for_role(role)
      senders = []
      MESSAGE_PERMISSION_HASH.each_pair do |sender, receivers|
        senders << sender if receivers.include?(role)
      end

      senders
    end

  end

end
