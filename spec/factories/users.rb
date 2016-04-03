FactoryGirl.define do
    factory :user do
        email { Faker::Internet.email }
        name { Faker::Name.name }
        password { Faker::Lorem.characters(8) }
        password_confirmation { "#{password}" }
        remember_me false
        role { 'parentee' }


        factory :admin do
            role { 'admin' }
        end
    end
end