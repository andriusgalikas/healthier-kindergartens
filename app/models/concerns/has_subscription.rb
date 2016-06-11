module HasSubscription
    extend ActiveSupport::Concern

    included do
        has_one :subscription
        has_one :plan,                          through: :subscription

        scope :subscribed,                      -> { includes(:subscription).where.not(subscription: { id: nil } ) }
        scope :unsubscribed,                    -> { includes(:subscription).where(subscription: { id: nil } ) }

        # => Checks if a user has an active subscription
        #
        def subscribed?
            subscription.nil? || active_trial? ? false : true
        end

        # => Checks if a user has an only active subscription 
        #
        def active_subscribed?
            subscription.nil? ? false : true
        end

        # => Checks if a user has an active trial
        #
        def active_trial?
            trial_end_date > Time.now ? true : false
        end

        # => Checks if a user does not have an active subscription
        #
        def unsubscribed?
            subscription.nil? ? true : false
        end

        # => Checks if a user is valid for a reminder email if they have not yet subscribed yet
        #
        def reminder_user?
            self.created_at.to_date === 3.days.ago.to_date ? true : false
        end

        # => Checks if user is within first n users (used for discount code FIRST100 logic)
        #
        def within_first? counter
            User.manager.count <= counter ? true : false
        end
    end
end