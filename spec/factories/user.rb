FactoryBot.define do
  factory :user do
    email{Faker::Internet.email}
    name{Faker::Name.name}
    password{"111111"}
    password_confirmation{"111111"}
  end
end
