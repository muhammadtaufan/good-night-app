require 'rails_helper'

RSpec.describe V1::TimeEventsController, type: :controller do
  let!(:user) { create(:user) }
  let(:headers) { { 'Authorization' => user.auth_token } }
  let!(:sleep_time) { create(:time_event, user: user, is_time_in: true) }
  let!(:wake_up) { create(:time_event, user: user, is_time_in: false, event_time: sleep_time.event_time + 1.hour) }

  describe 'GET #index' do
    before do
      request.headers.merge!(headers)
      get :index
    end

    it 'returns time events' do
      json_response = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json_response['data'].first['id']).to eq(sleep_time.id)
      expect(json_response['data'].second['id']).to eq(wake_up.id)
    end
  end

  describe 'POST #sleep' do
    let(:new_sleep_time) { Time.new(2023, 4, 1, 8, 0) }
    let(:valid_attributes) { { time_event: { event_time: new_sleep_time } } }

    before do
      request.headers.merge!(headers)
      post :sleep, params: valid_attributes
    end

    it 'creates a sleep time event' do
      json_response = JSON.parse(response.body)

      expect(response.status).to eq(201)
      expect(json_response['data']['is_time_in']).to eq(true)
    end
  end

  describe 'POST #wake_up' do
    let!(:new_sleep_time) { create(:time_event, user: user, is_time_in: true, event_time: Time.new(2023, 4, 1, 8, 0)) }
    let(:wake_up_time) { Time.new(2023, 4, 1, 12, 0) }
    let(:valid_attributes) { { time_event: { event_time: wake_up_time } } }

    before do
      request.headers.merge!(headers)
      post :wake_up, params: valid_attributes
    end

    it 'creates a wake up time event' do
      json_response = JSON.parse(response.body)

      expect(response.status).to eq(201)
      expect(json_response['data']['is_time_in']).to eq(false)
    end
  end
end
