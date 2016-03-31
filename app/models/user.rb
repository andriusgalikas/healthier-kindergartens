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
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

    has_one :user_daycare
    has_one :daycare,                                   through: :user_daycare

    has_many :todo_completes,                           foreign_key: 'submitter_id'
    has_many :completed_todos,                          -> { where.not(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'
    has_many :incomplete_todos,                         -> { where.not(id: nil).where(completion_date: nil) }, class_name: 'TodoComplete', foreign_key: 'submitter_id'


    validates :name, :email, :role,                      presence: true

    enum role: [:parentee, :worker, :manager, :admin]

    def available_todos
        daycare.all_todos.reject{|t| active_todos.map(&:todo_id).include? t.id }
    end

    def active_todos
        (completed_todos + incomplete_todos)
    end
end