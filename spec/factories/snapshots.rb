# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :snapshot do
    URL "MyString"
    like_count 1
    unlike_count 1
    flag_count 1
    user nil
  end
end
