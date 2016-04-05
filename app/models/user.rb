# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer          default("0")
#  name                   :string
#  stripe_customer_token  :string
#  department_id          :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
    include HasMailchimp
    include HasSubscription
    include HasDiscountCode
    include HasTodos
    include HasOccurrences
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    has_one :user_daycare,                                       dependent: :destroy
    has_one :daycare,                                            through: :user_daycare
    has_many :children,                                          class_name: 'Child', foreign_key: 'parent_id'

    belongs_to :department

    validates :department_id,                                   presence: true, :if => :worker?

    validates :name, :email, :role,                             presence: true

    validates :children,                                        presence: true, :if => :parentee? 
    validates :user_daycare,                                    presence: true, unless: :admin?

    enum role: [:parentee, :worker, :manager, :admin]

    accepts_nested_attributes_for :children, :user_daycare
end
