require 'rails_helper'

RSpec.describe ProductExchangeService do
  let(:requester) { create :user }
  let(:receiver) { create :user }

  describe '#valid?' do

    let(:params_exchange) do
      {
        products_requester: [
          { product: 'desktop_gamer', quantity: 1 }
        ],
        receiver: receiver.id,
        products_receiver: [
          { product: 'notebook', quantity: 1 },
          { product: 'smartphone', quantity: 1 }

        ]
      }
    end

    context 'product quantity' do

      it "false when requester doesn't have any products to exchange" do


        params_exchange = {
          products_requester: [],
          receiver: receiver.id,
          products_receiver: []
        }

        exchange = ProductExchangeService.new requester, params_exchange

        expect(exchange.valid?).to eq(false)

        expect(exchange.errors).to include("Empty field for requester to exchange products")
      end

      it "false when receiver doesn't have any products to exchange" do
        params_exchange = {
          products_requester: [],
          receiver: receiver.id,
          products_receiver: []
        }

        exchange = ProductExchangeService.new requester, params_exchange

        expect(exchange.valid?).to eq(false)

        expect(exchange.errors).to include("Empty field for receiver to exchange products")
      end

      it "false when requester doesn't have the products" do
        exchange = ProductExchangeService.new requester, params_exchange

        expect(exchange.valid?).to eq(false)

        expect(exchange.errors).to include("Requester doesn't have the products")
      end

      it "false when requester doesn't have enough quantity of products" do
        create :inventory, product: 'notebook', user: requester, quantity: 1

        params_exchange = {
          products_requester: [
            { product: 'notebook', quantity: 2 }
          ],
          receiver: receiver.id,
          products_receiver: []
        }

        exchange = ProductExchangeService.new requester, params_exchange

        expect(exchange.valid?).to eq(false)

        expect(exchange.errors).to include("Requester doesn't have enough quantity of products")
      end

      it "false when receiver doesn't have the products" do
        exchange = ProductExchangeService.new requester, params_exchange

        expect(exchange.valid?).to eq(false)

        expect(exchange.errors).to include("Receiver doesn't have the products")
      end

      it "false when receiver doesn't have enough quantity of products" do
        create :inventory, product: 'notebook', user: receiver, quantity: 1

        params_exchange = {
          products_requester: [],
          receiver: receiver.id,
          products_receiver: [
            { product: 'notebook', quantity: 2 }
          ]
        }

        exchange = ProductExchangeService.new requester, params_exchange

        expect(exchange.valid?).to eq(false)

        expect(exchange.errors).to include("Receiver doesn't have enough quantity of products")
      end
    end
  end
end
