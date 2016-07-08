FactoryGirl.define do
  factory :mens_hoodie do
    version 1
    base_name 'hoodie'
    type 'Long Sleeve'
    style "Mens Hoodie"
    gender "Male"
    price 45
    sizes ["S","M","L","XL","XXL","XXXL"]
    weight 908
    handle_extension "-winter"
  end
end
