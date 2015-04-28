FactoryGirl.define do
  factory :user do
    name { FFaker::Name.name }
    username { FFaker::Internet.user_name }
    role "user"
    email { FFaker::Internet.email }
    password "password"
    password_confirmation "password"
  end
  factory :admin, class: User do
    name { FFaker::Name.name }
    username { FFaker::Internet.user_name }
    role "admin"
    email { FFaker::Internet.email }
    password "password"
    password_confirmation "password"
  end
  factory :api_full, class: User do
    name { FFaker::Name.name }
    username { FFaker::Internet.user_name }
    role "api_full"
    email { FFaker::Internet.email }
    password "password"
    password_confirmation "password"
  end
  factory :api_insert, class: User do
    name { FFaker::Name.name }
    username { FFaker::Internet.user_name }
    role "api_insert"
    email { FFaker::Internet.email }
    password "password"
    password_confirmation "password"
  end
  factory :api_read, class: User do
    name { FFaker::Name.name }
    username { FFaker::Internet.user_name }
    role "api_read"
    email { FFaker::Internet.email }
    password "password"
    password_confirmation "password"
  end

  factory :user_invalid, class: User do
    name nil
    username nil
    role "non-existing role"
    email "not-a-valid-email-address"
    password "these passwords"
    password_confirmation "are not matching"
  end
end
