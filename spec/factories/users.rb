FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "person #{n}" }
    sequence(:username) { |n| "person#{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    birth_date { "2020-07-19" }
    country { "Brazil" }
  end
end
