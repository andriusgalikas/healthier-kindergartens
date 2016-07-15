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
#  trial_end_date         :datetime
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
    include HasTrial
    include HasVotes
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    has_one :user_daycare,                                       dependent: :destroy
    has_one :daycare,                                            through: :user_daycare
    has_many :children,                                          class_name: 'Child', foreign_key: 'parent_id'
    has_many :votes, as: :voter

    has_one :user_affiliate,                                    dependent: :destroy
    has_one :affiliate,                                         through: :user_affiliate

    has_many :messages,                                         foreign_key: 'owner_id'

    has_many :notifications,                                    foreign_key: 'target_id'

    belongs_to :department

    has_many :health_records,                                   :as => :recorder

    validates :department_id,                                   presence: true, :if => :worker?

    validates :name, :email, :role,                             presence: true

    validates :children,                                        presence: true, :if => :parentee?


    enum role: [:parentee, :worker, :manager, :admin, :partner]

    accepts_nested_attributes_for :children, :user_daycare, :user_affiliate, allow_destroy: true

    def newly_signed_up?
      sign_in_count == 1
    end
end
