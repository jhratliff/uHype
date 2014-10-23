# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    user nil
    school nil
    detail "MyString"
    flag_count 1
    like_count 1
    unlike_count 1
  end
end
