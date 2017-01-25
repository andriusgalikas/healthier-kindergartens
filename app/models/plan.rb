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
#  plan_type  :integer
#  language   :string
#

class Plan < ActiveRecord::Base
    has_many :subscriptions
    has_many :users,                                      through: :subscriptions

    validates :plan_type, :price, :language,                   presence: true

    default_scope { order(allocation: :asc) }

    scope :by_language,     ->(search) { where("(LOWER(plans.language) LIKE :search)", :search => "%#{search.downcase}%") }
end
