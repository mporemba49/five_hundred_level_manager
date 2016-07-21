hoodie = Clothing.where(
  base_name: 'Mens Hoodie'
).first_or_create
hoodie.update_attributes(
  clothing_type: 'Long Sleeve',
  style: 'Mens Hoodie',
  gender: 'Male',
  price: 45,
  sizes: ["S","M","L","XL","XXL","XXXL"],
  weight: 908,
  extension: 'WINTER'
)

hoodie.add_tags(["Mens Hoodie", "Crew Sweatshirt", "Zip Hoodie", "Lace Hoodie", "Long Sleeve"])

zip_hoodie = Clothing.where(
  base_name: 'Zip Hoodie'
).first_or_create
zip_hoodie.update_attributes(
  clothing_type: 'Long Sleeve',
  style: 'Zip Hoodie',
  gender: 'Male',
  price: 50,
  sizes: ["S","M","L","XL","XXL"],
  weight: 908,
  extension: 'WINTER'
)
zip_hoodie.add_tags(["Mens Hoodie", "Crew Sweatshirt", "Zip Hoodie", "Lace Hoodie", "Long Sleeve"])

lace_hoodie = Clothing.where(
  base_name: 'Lace Hoodie'
).first_or_create
lace_hoodie.update_attributes(
  clothing_type: 'Long Sleeve',
  style: 'Lace Hoodie',
  gender: 'Male',
  price: 50,
  sizes: ["S","M","L","XL","XXL", "XXXL"],
  weight: 908,
  extension: 'WINTER'
)
lace_hoodie.add_tags(["Mens Hoodie", "Crew Sweatshirt", "Zip Hoodie", "Lace Hoodie", "Long Sleeve"])

crew_sweatshirt = Clothing.where(
  base_name: 'Crew Sweatshirt'
).first_or_create
crew_sweatshirt.update_attributes(
  clothing_type: 'Long Sleeve',
  style: 'Crew Sweatshirt',
  gender: 'Male',
  price: 45,
  sizes: ["S","M","L","XL","XXL"],
  weight: 454,
  extension: 'WINTER'
)
crew_sweatshirt.add_tags(["Mens Hoodie", "Crew Sweatshirt", "Zip Hoodie", "Lace Hoodie", "Long Sleeve"])

long_sleeve = Clothing.where(
  base_name: 'Long Sleeve'
).first_or_create
long_sleeve.update_attributes(
  clothing_type: 'Long Sleeve',
  style: 'Long Sleeve',
  gender: 'Male',
  price: 32,
  sizes: ["S","M","L","XL","XXL"],
  weight: 227,
  extension: 'WINTER'
)
long_sleeve.add_tags(["Mens Hoodie", "Crew Sweatshirt", "Zip Hoodie", "Lace Hoodie", "Long Sleeve"])

w_hoodie_sleeve = Clothing.where(
  base_name: 'Womens Hoodie'
).first_or_create
w_hoodie_sleeve.update_attributes(
  clothing_type: 'Long Sleeve',
  style: 'Womens Hoodie',
  gender: 'Women',
  price: 45,
  sizes: ["S","M","L","XL"],
  weight: 908,
  extension: 'WINTER'
)
w_hoodie_sleeve.add_tags(["Womens Hoodie", "Maniac Sweatshirt"])

maniac = Clothing.where(
  base_name: 'Maniac Sweatshirt'
).first_or_create
maniac.update_attributes(
  clothing_type: 'Long Sleeve',
  style: 'Maniac Sweatshirt',
  gender: 'Women',
  price: 45,
  sizes: ["S","M","L","XL"],
  weight: 454,
  extension: 'WINTER'
)
maniac.add_tags(["Womens Hoodie", "Maniac Sweatshirt"])

m_tshirt = Clothing.where(
  base_name: 'Mens T-Shirt'
).first_or_create
m_tshirt.update_attributes(
  clothing_type: 'T-Shirt',
  style: 'Mens T-Shirt',
  gender: 'Male',
  price: 27,
  sizes: ["S","M","L","XL", "XXL"],
  weight: 318,
)
m_tshirt.add_tags(["T-Shirt", "V-Neck", "Tank Top"])

w_tshirt = Clothing.where(
  base_name: 'Womens T-Shirt'
).first_or_create
w_tshirt.update_attributes(
  clothing_type: 'T-Shirt',
  style: 'Womens T-Shirt',
  gender: 'Women',
  price: 27,
  sizes: ["S","M","L","XL", "XXL"],
  weight: 318,
)
w_tshirt.add_tags(["Scoop Neck", "T-Shirt", "Fine Jersey T-Shirt", "V-Neck", "Tank Top"])

t_tshirt = Clothing.where(
  base_name: 'Toddler T-Shirt'
).first_or_create
t_tshirt.update_attributes(
  clothing_type: 'T-Shirt',
  style: 'Toddler T-Shirt',
  gender: 'Kids',
  price: 17,
  sizes: ["2","4/5","6/7"],
  weight: 136,
)
t_tshirt.add_tags(["Onesie","Toddler T-Shirt","Youth T-Shirt"])

y_tshirt = Clothing.where(
  base_name: 'Youth T-Shirt'
).first_or_create
y_tshirt.update_attributes(
  clothing_type: 'T-Shirt',
  style: 'Youth T-Shirt',
  gender: 'Kids',
  price: 19,
  sizes: ["8","10/12","14/16"],
  weight: 136,
)
y_tshirt.add_tags(["Onesie","Toddler T-Shirt","Youth T-Shirt"])

y_hoodie = Clothing.where(
  base_name: 'Youth Hoodie'
).first_or_create
y_hoodie.update_attributes(
  clothing_type: 'Long Sleeve',
  style: 'Youth Hoodie',
  gender: 'Kids',
  price: 35,
  sizes: ["S","M","L","XL"],
  weight: 908,
  extension: 'WINTER'
)
y_hoodie.add_tags(["Youth Hoodie"])

jersey = Clothing.where(
  base_name: "Fine Jersey T-Shirt"
).first_or_create
jersey.update_attributes(
  clothing_type: 'T-Shirt',
  style: "Fine Jersey T-Shirt",
  gender: 'Women',
  price: 27,
  sizes: ["S","M","L","XL", "XXL"],
  weight: 318,
)
jersey.add_tags(["Scoop Neck", "T-Shirt", "Fine Jersey T-Shirt", "V-Neck", "Tank Top"])

m_vneck = Clothing.where(
  base_name: "Mens V-Neck"
).first_or_create
m_vneck.update_attributes(
  clothing_type: 'T-Shirt',
  style: "V-Neck",
  gender: 'Male',
  price: 27,
  sizes: ["XS", "S","M","L","XL", "XXL"],
  weight: 318,
)
m_vneck.add_tags(["T-Shirt", "V-Neck", "Tank Top"])

w_vneck = Clothing.where(
  base_name: "Mens V-Neck"
).first_or_create
w_vneck.update_attributes(
  clothing_type: 'T-Shirt',
  style: "V-Neck",
  gender: 'Women',
  price: 27,
  sizes: ["S","M","L","XL", "XXL"],
  weight: 318,
)
w_vneck.add_tags(["Scoop Neck", "T-Shirt", "Fine Jersey T-Shirt", "V-Neck", "Tank Top"])

m_tank = Clothing.where(
  base_name: "Mens Tank Top"
).first_or_create
m_tank.update_attributes(
  clothing_type: 'T-Shirt',
  style: "Tank Top",
  gender: 'Male',
  price: 27,
  sizes: ["XS","S","M","L","XL"],
  weight: 318,
)
m_tank.add_tags(["T-Shirt","V-Neck","Tank Top"])

w_tank = Clothing.where(
  base_name: "Women Tank Top"
).first_or_create
w_tank.update_attributes(
  clothing_type: 'T-Shirt',
  style: "Tank Top",
  gender: 'Women',
  price: 27,
  sizes: ["S","M","L","XL"],
  weight: 318,
)
w_tank.add_tags(["Scoop Neck", "T-Shirt", "Fine Jersey T-Shirt", "V-Neck", "Tank Top"])

scoop = Clothing.where(
  base_name: "Scoop Neck"
).first_or_create
scoop.update_attributes(
  clothing_type: 'T-Shirt',
  style: "Scoop Neck",
  gender: 'Women',
  price: 27,
  sizes: ["S","M","L","XL"],
  weight: 318,
)
scoop.add_tags(["Scoop Neck", "T-Shirt", "Fine Jersey T-Shirt", "V-Neck", "Tank Top"])

onesie = Clothing.where(
  base_name: "Onesie"
).first_or_create
onesie.update_attributes(
  clothing_type: 'Onesie',
  style: "Onesie",
  gender: 'Kids',
  price: 17,
  sizes: ["3-6M","6-12M","12-18M","18-24M"],
  weight: 136,
)
onesie.add_tags(["Onesie","Toddler T-Shirt","Youth T-Shirt"])
