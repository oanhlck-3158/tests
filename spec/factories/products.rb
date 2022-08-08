FactoryBot.define do
  factory :random_product, class: Product do
    name {Faker::Food.fruits}
    slug { [ERB::Util.url_encode(name),
        Digest::MD5.hexdigest(name + SecureRandom.uuid)[0..5]].join("-") }
    price { Faker::Number.within(range: 1..100) * 1e3 }
    description { Faker::Food.description} 
    quantity {Faker::Number.between from: 1, to: 10}
  end
end
