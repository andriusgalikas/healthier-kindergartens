module Deactivatable
  extend ActiveSupport::Concern

  included do
    def active?
      self.deactivated_at.nil?
    end

    def inactive?
      !active?
    end

    def activate!
      self.deactivated_at = nil
      save!
    end

    def deactivate!
      self.deactivated_at = Time.now
      save!
    end
  end

end
