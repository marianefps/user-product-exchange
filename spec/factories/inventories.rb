FactoryBot.define do
  factory :inventory do
    product { 'desktop_gamer' }
    quantity { 1 }
    association :user
  end
end
