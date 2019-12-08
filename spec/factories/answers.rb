FactoryBot.define do
  factory :answer do
    body { "OtherText" }

    trait :invalid do
      body { nil }
    end
  end
end
