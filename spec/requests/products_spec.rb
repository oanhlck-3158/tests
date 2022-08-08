require 'rails_helper'

RSpec.describe "/products", type: :request do
  let(:valid_attributes) {{
    name: "name",
    description: "description",
    quantity: 20,
    price: 20000
  }}
  let(:invalid_attributes) {{
    name: "name",
    quantity: 20,
    price: 20000
  }}
  let(:valid_headers) {
    {
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MzMsImV4cCI6MTY1OTk0NjI2NX0.0kkI0j-B4w5NRc2rdO9UhTUPY8RaaXd9nz1BmYmC5x8"
    }
  }

  describe "GET #index" do
    let!(:products) {FactoryBot.create_list :product, 20}
    before {get "/products"}

    it "returns 20 questions" do
      expect(JSON.parse(response.body).size).to eq 20
    end

    it "returns status code 200" do
      expect(response).to have_http_status 200
    end
  end

  describe "GET #show" do
    let!(:product) {create :product}

    context "when id does not exist" do
      before {get "/products/-1", params: }
      it "returns 404" do
        expect(response).to have_http_status 404
      end
    end

    context "when id exists" do
      before {get "/products/#{product.id}"}
      it "returns 200" do
        byebug
        expect(response).to have_http_status 200
      end

      it "returns product" do
        expect(JSON.parse(response.body)).to eq product
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Product" do
        expect {
          post products_url,
               params: { product: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Product, :count).by(1)
      end

      it "renders a JSON response with the new product" do
        post products_url,
             params: { product: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Product" do
        expect {
          post products_url,
               params: { product: invalid_attributes }, as: :json
        }.to change(Product, :count).by(0)
      end

      it "renders a JSON response with errors for the new product" do
        post products_url,
             params: { product: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  # describe "PATCH /update" do
  #   context "with valid parameters" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested product" do
  #       product = Product.create! valid_attributes
  #       patch product_url(product),
  #             params: { product: new_attributes }, headers: valid_headers, as: :json
  #       product.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "renders a JSON response with the product" do
  #       product = Product.create! valid_attributes
  #       patch product_url(product),
  #             params: { product: new_attributes }, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:ok)
  #       expect(response.content_type).to match(a_string_including("application/json"))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "renders a JSON response with errors for the product" do
  #       product = Product.create! valid_attributes
  #       patch product_url(product),
  #             params: { product: invalid_attributes }, headers: valid_headers, as: :json
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(response.content_type).to match(a_string_including("application/json"))
  #     end
  #   end
  # end

  # describe "DELETE /destroy" do
  #   it "destroys the requested product" do
  #     product = Product.create! valid_attributes
  #     expect {
  #       delete product_url(product), headers: valid_headers, as: :json
  #     }.to change(Product, :count).by(-1)
  #   end
  # end
end
