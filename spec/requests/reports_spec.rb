require 'rails_helper'

RSpec.describe "API ReportsController", type: :request do


  describe "GET /api/reports/percentage_users_on_vacation" do

    context 'when has users' do
      it 'returns status ok' do
        create_list :user, 2, on_vacation: false
        get reports_percentage_users_on_vacation_path
        expect(response).to have_http_status(:ok)
      end

      it 'return json percentage_users_on_vacation 0 when there is no user on vacation' do
        create_list :user, 2, on_vacation: false
        get reports_percentage_users_on_vacation_path
        expect(json[:percentage_users_on_vacation]).to eq(0)
      end

      it 'return json percentage_users_on_vacation 100 when all users are on vacation' do
        create_list :user, 2, on_vacation: true
        get reports_percentage_users_on_vacation_path
        expect(json[:percentage_users_on_vacation]).to eq(100)
      end

      it 'return json percentage_users_on_vacation 25 when one quarter of users are on vacation' do
        create_list :user, 3, on_vacation: false
        create :user, on_vacation: true
        get reports_percentage_users_on_vacation_path
        expect(json[:percentage_users_on_vacation]).to eq(25)
      end
    end

    context 'when without users' do
      before { get reports_percentage_users_on_vacation_path  }

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'return json percentage_users_on_vacation 0' do
        expect(json[:percentage_users_on_vacation]).to eq(0)
      end
    end

  end

  describe "GET /api/reports/percentage_users_working" do

    context 'when has users' do
      it 'returns status ok' do
        create_list :user, 2, on_vacation: true
        get reports_percentage_users_working_path
        expect(response).to have_http_status(:ok)
      end

      it 'return json percentage_users_working 75 when tree quarters of users are working' do
        create_list :user, 3, on_vacation: false
        create :user, on_vacation: true
        get reports_percentage_users_working_path
        expect(json[:percentage_users_working]).to eq(75)
      end

      it 'return json percentage_users_working 0 when there is no user working' do
        create_list :user, 2, on_vacation: true
        get reports_percentage_users_working_path
        expect(json[:percentage_users_working]).to eq(0)
      end

      it 'return json percentage_users_working 100 when all users are working' do
        create_list :user, 2, on_vacation: false
        get reports_percentage_users_working_path
        expect(json[:percentage_users_working]).to eq(100)
      end
    end

    context 'when without users' do
      before { get reports_percentage_users_working_path  }

      it 'returns status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'return json percentage_users_working 0' do
        expect(json[:percentage_users_working]).to eq(0)
      end
    end
  end

  describe "GET /api/reports/total_price_equipments_on_vacation" do
    let(:user_working) { create :user, on_vacation: false }
    let(:user_on_vacation_a) { create :user, on_vacation: true }
    let(:user_on_vacation_b) { create :user, on_vacation: true }

    it 'return http status ok' do
      get reports_total_price_equipments_on_vacation_path
      expect(response).to have_http_status(:ok)
    end

    it "return total_price_equipments_on_vacation 0 when there is no users equipment on vacation" do
      create :inventory, user: user_working

      get reports_total_price_equipments_on_vacation_path
      expect(json[:total_price_equipments_on_vacation]).to eq(0)
    end

    it 'return total_price_equipments_on_vacation only user on vacation'  do
      create :inventory, user: user_working
      create :inventory, user: user_on_vacation_a, product: 'desktop_gamer'
      create :inventory, user: user_on_vacation_a, product: 'notebook', quantity: 2
      create :inventory, user: user_on_vacation_a, product: 'mouse'


      create :inventory, user: user_on_vacation_b, product: 'laser_printer'
      create :inventory, user: user_on_vacation_b, product: 'smartphone'
      create :inventory, user: user_on_vacation_b, product: 'mouse'

      get reports_total_price_equipments_on_vacation_path
      expect(json[:total_price_equipments_on_vacation]).to eq(872)
    end

  end

  describe 'GET /api/reports/avg_users_equipment' do
    let(:user_working) { create :user, on_vacation: false }
    let(:user_on_vacation) { create :user, on_vacation: true }

    it 'return http status ok' do
      get reports_avg_users_equipment_path
      expect(response).to have_http_status(:ok)
    end

    it 'return empty on avg_users_equipment when there are no inventories' do
      get reports_avg_users_equipment_path
      expect(json[:avg_users_equipment]).to be_empty
    end

    it 'return average equipment by user on avg_users_equipment' do
      create :inventory, user: user_working, product: 'desktop_gamer' # 1
      create :inventory, user: user_working, product: 'laser_printer' # 1

      create :inventory, user: user_working, product: 'notebook', quantity: 2 # 1
      create :inventory, user: user_working, product: 'mouse', quantity: 4 # 5

      create :inventory, user: user_on_vacation, product: 'laser_printer'
      create :inventory, user: user_on_vacation, product: 'notebook'
      create :inventory, user: user_on_vacation, product: 'smartphone'
      create :inventory, user: user_on_vacation, product: 'mouse', quantity: 6

      get reports_avg_users_equipment_path
      expect(json[:avg_users_equipment][:desktop_gamer]).to eq(1)
      expect(json[:avg_users_equipment][:laser_printer]).to eq(1)
      expect(json[:avg_users_equipment][:notebook]).to eq(1)
      expect(json[:avg_users_equipment][:mouse]).to eq(5)
      expect(json[:avg_users_equipment][:smartphone]).to eq(1)

    end

  end


end
