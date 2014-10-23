# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    user nil
    recipient_id 1
    detail "MyString"
    flag_count 1
  end
end
