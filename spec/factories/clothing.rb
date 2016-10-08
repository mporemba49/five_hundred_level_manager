FactoryGirl.define do
  factory :clothing do
    base_name      'Cotton T-Shirt'
    clothing_type  'T-Shirt'
    style          "Cotton T-Shirt"
    gender         'Men'
    price          27
    weight         318
    active         true
    sku            'NLC'
    extension      ''

    trait :inactive do
      active  false
    end

    trait :winter do
      extension "WINTER"
    end
  end
end
