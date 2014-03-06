# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :group do
    name "MyString"

    factory :public_group do
      visibility :visible_to_visitor
    end

    factory :hidden_group do
      visibility :visible_to_member
    end
  end
end
