FactoryBot.define do
    factory :default_user, class: User do
        email { "user@default.com" }
        password { "123456" }
    end
end