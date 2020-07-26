require 'rails_helper'

RSpec.describe ProductExchangeService do
  let(:requester) { create :user }
  let(:receiver) { create :user }

  describe '#save' do

    it 'false when invalid' do
      params_exchange = {
        products_requester: [],
        receiver: receiver.id,
        products_receiver: []
      }

      exchange = ProductExchangeService.new(requester, params_exchange)

      expect(exchange.save).to eq(false)
    end

    context 'product removal' do
      context 'when all products have been exchanged inventory will be destroyed' do
        before(:each) do
          create :inventory, product: 'laser_printer', user: requester, quantity: 2

          create :inventory, product: 'desktop_gamer', user: receiver, quantity: 1
        end
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

        it 'for requester' do
          exchange = ProductExchangeService.new(requester, params_exchange)

          expect(exchange.save).to be_truthy

          expect(requester.inventories.where(product: 'laser_printer').count).to eq(0)
        end

        it 'for receiver' do
          exchange = ProductExchangeService.new(requester, params_exchange)

          expect(exchange.save).to be_truthy

          expect(receiver.inventories.where(product: 'desktop_gamer').count).to eq(0)
        end
      end
      context 'when there is some product left inventory quantity will be deducted' do
        before(:each) do
          create :inventory, product: 'desktop_gamer', user: requester, quantity: 3

          create :inventory, product: 'laser_printer', user: receiver, quantity: 5
        end
        let(:params_exchange) do
          {
            products_requester: [
              { product: 'desktop_gamer', quantity: 1 }
            ],
            receiver: receiver.id,
            products_receiver: [
              { product: 'laser_printer', quantity: 2 }

            ]
          }
        end

        it 'for requester' do
          exchange = ProductExchangeService.new(requester, params_exchange)

          expect(exchange.save).to be_truthy

          expect(requester.inventories.find_by(product: 'desktop_gamer').quantity).to eq(2)
        end

        it 'for receiver' do
          exchange = ProductExchangeService.new(requester, params_exchange)

          expect(exchange.save).to be_truthy

          expect(receiver.inventories.find_by(product: 'laser_printer').quantity).to eq(3)
        end
      end
    end

    context 'product added' do
      context 'when the user does not have the product in the inventory' do
        before(:each) do
          create :inventory, product: 'notebook', user: requester, quantity: 2
          create :inventory, product: 'smartphone', user: requester, quantity: 2


          create :inventory, product: 'desktop_gamer', user: receiver, quantity: 2
        end
        let(:params_exchange) do
          {
            products_requester: [
              { product: 'notebook', quantity: 2 },
              { product: 'smartphone', quantity: 2}

            ],
            receiver: receiver.id,
            products_receiver: [
              { product: 'desktop_gamer', quantity: 2 }
            ]
          }
        end
        it 'the product that came from receiver will be created into inventory requester' do
          exchange = ProductExchangeService.new(requester, params_exchange)

          expect(exchange.save).to be_truthy

          expect(requester.inventories.find_by(product: 'desktop_gamer').quantity).to eq(2)
        end

        it 'the product that came from requester will be create into inventory receiver' do
          exchange = ProductExchangeService.new(requester, params_exchange)

          expect(exchange.save).to be_truthy

          expect(receiver.inventories.find_by(product: 'notebook').quantity).to eq(2)
          expect(receiver.inventories.find_by(product: 'smartphone').quantity).to eq(2)
        end
      end

      context 'when the user has the product in the inventory' do
        before(:each) do
          create :inventory, product: 'desktop_gamer', user: requester, quantity: 1
          create :inventory, product: 'notebook', user: requester, quantity: 2
          create :inventory, product: 'smartphone', user: requester, quantity: 1

          create :inventory, product: 'notebook', user: receiver, quantity: 2
          create :inventory, product: 'smartphone', user: receiver, quantity: 1
          create :inventory, product: 'desktop_gamer', user: receiver, quantity: 2
        end
        let(:params_exchange) do
          {
            products_requester: [
              { product: 'desktop_gamer', quantity: 1 }
            ],
            receiver: receiver.id,
            products_receiver: [
              { product: 'notebook', quantity: 1 },
              { product: 'smartphone', quantity: 1}
            ]
          }
        end
        it 'the product that came from receiver will be added into inventory requester' do
          exchange = ProductExchangeService.new(requester, params_exchange)

          expect(exchange.save).to be_truthy

          expect(requester.inventories.find_by(product: 'notebook').quantity).to eq(3)
          expect(requester.inventories.find_by(product: 'smartphone').quantity).to eq(2)

        end

        it 'the product  that came from requester will be added into inventory receiver' do
          exchange = ProductExchangeService.new(requester, params_exchange)

          expect(exchange.save).to be_truthy

          expect(receiver.inventories.find_by(product: 'desktop_gamer').quantity).to eq(3)
        end
      end
    end

  end

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

        expect(exchange.errors).to include('Empty field for requester to exchange products')
      end

      it "false when receiver doesn't have any products to exchange" do
        params_exchange = {
          products_requester: [],
          receiver: receiver.id,
          products_receiver: []
        }

        exchange = ProductExchangeService.new requester, params_exchange

        expect(exchange.valid?).to eq(false)

        expect(exchange.errors).to include('Empty field for receiver to exchange products')
      end

      it "false when requester doesn't have the products" do
        params_exchange = {
          products_requester: [
            { product: 'notebook', quantity: 2 }
          ],
          receiver: receiver.id,
          products_receiver: []
        }
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
        params_exchange = {
          products_requester: [
            { product: 'notebook', quantity: 2 }
          ],
          receiver: receiver.id,
          products_receiver: [{ product: 'notebook', quantity: 2 }]
        }
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

    it 'false when the values amount are different' do
      create :inventory, product: 'notebook', user: requester, quantity: 2

      create :inventory, product: 'smartphone', user: receiver, quantity: 1
      create :inventory, product: 'mouse', user: receiver, quantity: 2

      params_exchange = {
        products_requester: [
          { product: 'notebook', quantity: 2 }
        ],
        receiver: receiver.id,
        products_receiver: [
          { product: 'smartphone', quantity: 1 },
          { product: 'mouse', quantity: 2 }

        ]
      }

      exchange = ProductExchangeService.new requester, params_exchange

      expect(exchange.valid?).to eq(false)

      expect(exchange.errors).to include('Values amount exchange are different')
    end

    it 'false when the kind of requester product is not in the list' do
      params_exchange = {
        products_requester: [
          { product: 'smartphone', quantity: 1 },
          { product: 'monitor', quantity: 2 }
        ],
        receiver: receiver.id,
        products_receiver: [{ product: 'smartphone', quantity: 1 }]
      }

      exchange = ProductExchangeService.new requester, params_exchange

      expect(exchange.valid?).to eq(false)

      expect(exchange.errors).to include('This requester kind of product does not exist')
    end
    it 'false when the kind of receiver product is not in the list' do
      params_exchange = {
        products_requester: [
          { product: 'smartphone', quantity: 1 }
        ],
        receiver: receiver.id,
        products_receiver: [
          { product: 'smartphone', quantity: 1 },
          { product: 'monitor', quantity: 2 }
        ]
      }

      exchange = ProductExchangeService.new requester, params_exchange

      expect(exchange.valid?).to eq(false)

      expect(exchange.errors).to include('This receiver kind of product does not exist')
    end

    it 'false when requester is on vacation' do
      params_exchange = {
        products_requester: [],
        receiver: receiver.id,
        products_receiver: []
      }

      requester.update on_vacation: true
      exchange = ProductExchangeService.new requester, params_exchange
      expect(exchange.valid?).to eq(false)

      expect(exchange.errors).to include('Inventory is unavailable for requester')
    end
    it 'false when receiver is on vacation' do
      params_exchange = {
        products_requester: [],
        receiver: receiver.id,
        products_receiver: []
      }

      receiver.update on_vacation: true
      exchange = ProductExchangeService.new requester, params_exchange
      expect(exchange.valid?).to eq(false)

      expect(exchange.errors).to include('Inventory is unavailable for receiver')
    end
  end
end
