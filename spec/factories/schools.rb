# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :school do
    name "MyString"
    address "MyString"
    city "MyString"
    state "MyString"
    zip "MyString"
    maplink "MyText"
    stype "MyString"
    grades "MyString"
    website "MyString"
  end
end
