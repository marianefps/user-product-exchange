require 'rails_helper'

RSpec.describe ProductExchangeService do
  let(:requester) { create :user }
  let(:receiver) { create :user }

  describe '#valid?' do
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

    it "false when the values amount are different" do
      create :inventory, product: 'notebook', user: requester, quantity: 2

      create :inventory, product: 'smartphone', user: receiver, quantity: 1
      create :inventory, product: 'mouse', user: receiver, quantity: 2

      params_exchange = {
        products_requester: [
          { product: 'notebook', quantity: 2 }
        ],
        receiver: receiver.id,
        products_receiver: [
          { product: 'smartphone', quantity: 1},
          { product: 'mouse', quantity: 2 }

        ]
      }

      exchange = ProductExchangeService.new requester, params_exchange

      expect(exchange.valid?).to eq(false)

      expect(exchange.errors).to include("Values amount exchange are different")
    end

    it "false when the kind of requester product is not in the list" do
      params_exchange = {
        products_requester: [
          { product: 'smartphone', quantity: 1},
          { product: 'monitor', quantity: 2 }
        ],
        receiver: receiver.id,
        products_receiver: [{ product: 'smartphone', quantity: 1}]
      }

      exchange = ProductExchangeService.new requester, params_exchange

      expect(exchange.valid?).to eq(false)

      expect(exchange.errors).to include("This requester kind of product does not exist")
    end
    it "false when the kind of receiver product is not in the list" do
      params_exchange = {
        products_requester: [
          { product: 'smartphone', quantity: 1}
        ],
        receiver: receiver.id,
        products_receiver: [
          {product: 'smartphone', quantity: 1},
          { product: 'monitor', quantity: 2 }
        ]
      }

      exchange = ProductExchangeService.new requester, params_exchange

      expect(exchange.valid?).to eq(false)

      expect(exchange.errors).to include("This receiver kind of product does not exist")
    end
  end
end
