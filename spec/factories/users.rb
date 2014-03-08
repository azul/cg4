# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    password 'changeme'
    password_confirmation 'changeme'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now

    factory :public_user do
      visibility :visible_to_visitor
    end

    factory :hidden_user do
      visibility :visible_to_self
    end
  end
end
