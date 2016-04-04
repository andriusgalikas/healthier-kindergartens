# == Schema Information
#
# Table name: plans
#
#  id         :integer          not null, primary key
#  name       :string
#  price      :decimal(, )      default("0.0")
#  allocation :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Plan < ActiveRecord::Base
    has_many :subscriptions
    has_many :users,                                        through: :subscriptions

    validates :name, :price, :allocation,                   presence: true

    after_create :send_to_stripe

    def send_to_stripe
        UpdateStripePlansCouponsJob.perform_later
    end
end
