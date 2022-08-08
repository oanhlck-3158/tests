require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:valid_product){{
    name: "name",
    description: "description",
    quantity: 20,
    price: 20000
  }}
  let(:invalid_product){{
    name: "name",
    quantity: 20,
    price: 20000
  }}

  token_headers = {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MzMsImV4cCI6MTY1OTk1OTY0Nn0.KE9i6XeStmypNYhW4g0m3Ld090kGFr3tIVFiWxKDn1A"
  }

  let(:expired_token_headers){{
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MzMsImV4cCI6MTY1OTk0NjI2NX0.0kkI0j-B4w5NRc2rdO9UhTUPY8RaaXd9nz1BmYmC5x8"
  }}

  describe "GET #index" do
    let!(:products) {create_list :random_product, 20}
    before {get :index, params: { size: 10, page: 0 }}

    it do
      expect(JSON.parse(response.body).size).to eq 10
      expect(response).to have_http_status 200
    end
  end

  describe "GET #show" do
    let(:product) {create :random_product}

    context "when id exists" do
      before {get :show, params: {id: product.id}}

      it do
        expect(response).to have_http_status 200
        expect(JSON.parse(response.body)) == product
      end
    end
  end

  describe "POST #create" do
    context "when request with no authentication header" do
      it do
        expect { post :create, params: valid_product }.to change {Product.count}.by 0
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when request contains an authentication header" do
      before_count = Product.count
      token = "eyJhbGciOiJIUzI1NiJ9.eyJpZCI6MzMsImV4cCI6MTY1OTk1OTY0Nn0.KE9i6XeStmypNYhW4g0m3Ld090kGFr3tIVFiWxKDn1A"
      before do
        request.headers.merge! token_headers
        # request.headers["Authorization"] = "Bearer #{token}"
        post :create, params: valid_product
      end

      it do
        expect(response).to have_http_status :created
        expect(Product.count).not_to eq before_count
        expect(JSON.parse response.body) == valid_product
      end
    end

    context "when request with expired token" do
      before do
        request.headers.merge! expired_token_headers
        post :create, params: valid_product
      end
      it do
        expect(response).to have_http_status :unauthorized
        expect { post :create, params: valid_product }.to change {Product.count}.by 0
      end
    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      it "renders a JSON response with the product" do
        product = Product.create! valid_product
        put product_url(product),
              params: { name: "update name"}
        expect(response).to have_http_status :ok
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(product.reload.name).to eq "update name"
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the product" do
        product = Product.create! valid_product
        patch product_url(product),
              params: { name: ""  }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(product.reload.name).to eq "name"
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested product" do
      product = Product.create! valid_product
      expect {
        delete product_url(product)
      }.to change(Product, :count).by(-1)
    end
  end
end
