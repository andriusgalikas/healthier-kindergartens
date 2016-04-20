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

FactoryGirl.define do
    factory :user do
        email { Faker::Internet.email }
        name { Faker::Name.name }
        password { Faker::Lorem.characters(8) }
        password_confirmation { "#{password}" }
        remember_me false
        role { 'manager' }


        factory :admin do
            role { 'admin' }
        end

        factory :parentee do
            role { 'parentee' }
        end

        factory :worker do
            role { 'worker' }
        end
    end
end
