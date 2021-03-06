require 'rails_helper'

RSpec.describe "API UsersController", type: :request do


  describe "GET /api/users/:id" do
    let(:user) do
      create :user, inventories_attributes: [{product: 'notebook', quantity: 5 }]
    end

    before { get user_path(user) }

    it 'returns status code ok' do
      expect(response).to have_http_status(:ok)
    end

    it 'return user attributes' do

      expect(json[:id]).to eq(user.id)
      expect(json[:name]).to eq(user.name)
      expect(json[:email]).to eq(user.email)
      expect(json[:birth_date].to_date).to eq(user.birth_date)
      expect(json[:country]).to eq(user.country)
      expect(json[:username]).to eq(user.username)
      expect(json[:inventories].first[:product]).to eq('notebook')
      expect(json[:inventories].first[:quantity]).to eq(5)
    end
  end


  describe "POST /api/users" do
    context 'when the request is valid' do
      before { post users_path, params: valid_attributes }

      let(:valid_attributes) {
        { user: attributes_for(:user, username: 'marianefps') }
      }

      it 'creates a user' do
        expect(json[:username]).to eq('marianefps')
      end

      context 'with inventory' do
        let(:valid_attributes) {
          { user: attributes_for(:user, username: 'marianefps',
                                 inventories_attributes: [{product: 'notebook', quantity: 5 }]) }
        }

        it 'create a user' do
          expect(json[:id]).not_to be_nil
          expect(json[:name]).to eq(valid_attributes[:user][:name])
          expect(json[:email]).to eq(valid_attributes[:user][:email])
          expect(json[:birth_date].to_date).to eq(valid_attributes[:user][:birth_date])
          expect(json[:country]).to eq(valid_attributes[:user][:country])
          expect(json[:username]).to eq('marianefps')
          expect(json[:inventories].first[:product]).to eq('notebook')
          expect(json[:inventories].first[:quantity]).to eq(5)
        end
      end

      it 'returns status code created' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      before { post users_path, params: invalid_attributes }

      let(:invalid_attributes) {
        { user: attributes_for(:user, username: nil) }
      }

      it 'returns status unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a validation failure message' do
        expect(json[:message]).to match(/Validation failed:/)
      end
    end
  end

  describe 'PUT /api/users/:id' do
    let(:valid_attributes) { { user: { country: 'New Country' } } }
    let(:user) {create :user, country: 'old country' }
    context "when the record exists" do
      before { put user_path(user), params: valid_attributes}

      it 'update a user' do
        expect(response.body).to be_empty
        expect(user.reload.country).to eq('New Country')
      end

      it 'returns status no content' do
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the user record does not exist' do
        before(:each) do
          id = user.id
          user.destroy
          put user_path(id), params: valid_attributes
        end

        it 'returns status record not found' do
          expect(response).to have_http_status(:not_found)
        end

        it 'return not found message' do
          expect(json[:message]).to match(/Couldn't find User/)
        end
    end
  end

  describe "POST /api/users/:id/exchange" do
    let(:requester) { create :user }
    let(:receiver) { create :user }
    let(:params_exchange) do
      {
        products_requester: [
          { product: 'laser_printer', quantity: 2 }
        ],
        receiver: receiver.id,
        products_receiver: [
          { product: 'desktop_gamer', quantity: 1 }
        ]
      }
    end

    context 'when request succeed' do
      before(:each) do
        create :inventory, product: 'laser_printer', user: requester, quantity: 3
        create :inventory, product: 'desktop_gamer', user: receiver, quantity: 2
        post exchange_user_path(requester), params: {exchange: params_exchange}
      end

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'the products have been exchanged' do
        expect(requester.inventories.find_by(product: 'desktop_gamer').quantity).to eq(1)
        expect(requester.inventories.find_by(product: 'laser_printer').quantity).to eq(1)

        expect(receiver.inventories.find_by(product: 'desktop_gamer').quantity).to eq(1)
        expect(receiver.inventories.find_by(product: 'laser_printer').quantity).to eq(2)
      end
    end

    context 'when request fails' do
      before(:each) do
        create :inventory, product: 'mouse', user: requester, quantity: 3
        create :inventory, product: 'smartphone', user: receiver, quantity: 2
        post exchange_user_path(requester), params: {exchange: params_exchange}
      end

      it 'returns status unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a list of validations failure message' do
        expect(json[:message]).not_to be_empty
      end

      it 'the products have not been exchanged' do
        expect(requester.inventories.find_by(product: 'mouse').quantity).to eq(3)
        expect(requester.inventories.find_by(product: 'desktop_gamer')).to be_nil

        expect(receiver.inventories.find_by(product: 'smartphone').quantity).to eq(2)
        expect(receiver.inventories.find_by(product: 'laser_printer')).to be_nil
      end

    end
  end

  describe "PUT /api/users/:id/on_vacation" do
    let(:user) { create :user, on_vacation: false }

    before(:each) { put on_vacation_user_path(user) }

    it 'returns status http no content' do
      expect(response).to have_http_status(:no_content)
    end

    it 'user on vacation true' do
      user.reload
      expect(user.on_vacation?).to eq(true)
    end
  end

  describe "PUT /api/users/:id/return_vacation" do
    let(:user) { create :user, on_vacation: true }

    before(:each) { put return_vacation_user_path(user) }

    it 'returns status http no content' do
      expect(response).to have_http_status(:no_content)
    end

    it 'user on vacation false' do
      user.reload
      expect(user.on_vacation?).to eq(false)
    end
  end

end
