require 'faker'

def create_products 
    30.times do |i|
        name = (i < 15) ? Faker::Food.vegetables : Faker::Food.fruits
        description = Faker::Food.description
        quantity = Faker::Number.between(from: 0, to:100)
        price = Faker::Number.within(range: 1..100) * 1e3
        params = {
            name: name,
            description: description,
            quantity: quantity,
            price: price
        }
        Product.create!(params)
    end
end

create_products
