module HasSubscription
    extend ActiveSupport::Concern

    included do
        has_one :subscription
        has_one :plan,                          through: :subscription

        scope :subscribed,                      -> { includes(:subscription).where.not(subscription: { id: nil } ) }
        scope :unsubscribed,                    -> { includes(:subscription).where(subscription: { id: nil } ) }

        def subscribed?
            subscription.nil? ? false : true
        end

        def unsubscribed?
            subscription.nil? ? true : false
        end

        def reminder_user?
            self.created_at.to_date === 3.days.ago.to_date ? true : false
        end

        def within_first? counter
            User.managers.count <= counter ? true : false
        end
    end
end