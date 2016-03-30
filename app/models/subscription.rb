# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  plan_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Subscription < ActiveRecord::Base
    belongs_to :plan
    belongs_to :user

    validates :user_id, :plan_id,                       presence: true
    validates :user_id,                                 uniqueness: true

    attr_accessor :stripe_card_token

    def save_with_payment discount_code
        if valid?
            customer = Stripe::Customer.create(description: user.name, email: user.email, plan: plan_id, card: stripe_card_token, coupon: discount_code.try(:code))
            user.update_column(:stripe_customer_token, customer.id)
            user.create_discount_code_user(discount_code_id: discount_code.id) unless discount_code.nil?
            save!
        end
    rescue Stripe::InvalidRequestError => e
        logger.error "Stripe error while creating customer: #{e.message}"
        errors.add :base, "There was a problem with your credit card."
        false
    end
end
