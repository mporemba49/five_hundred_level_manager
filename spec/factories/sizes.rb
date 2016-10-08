FactoryGirl.define do
  factory :size do
    name    'S'
    sku     'SM'
    is_kids false
    ordinal 1

    trait :medium do
      name 'M'
      sku  'MD'
    end
  end
end
