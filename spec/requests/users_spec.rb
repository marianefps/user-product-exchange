require 'rails_helper'

RSpec.describe "API UsersController", type: :request do

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
          expect(json[:inventories].first[:product]).to eq('notebook')
          expect(json[:inventories].first[:quantity]).to eq(5)
        end
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post users_path, params: invalid_attributes }

      let(:invalid_attributes) {
        { user: attributes_for(:user, username: nil) }
      }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json[:message]).to match(/Validation failed:/)
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:valid_attributes) { { user: { country: 'New Country' } } }
    let(:user) {create :user, country: 'old country' }
    context "when the record exists" do
      before { put user_path(user), params: valid_attributes}

      it 'update a user' do
        expect(response.body).to be_empty
        expect(user.reload.country).to eq('New Country')
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

end
