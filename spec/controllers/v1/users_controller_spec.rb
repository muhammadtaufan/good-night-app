require 'rails_helper'
require 'pry'

RSpec.describe V1::UsersController, type: :controller do
  let!(:user_list) { create_list(:user, 5) }
  let(:user_id) { user_list.first.id }

  describe 'GET #index' do
    before do
      get :index
    end

    it 'returns users' do
      json_response = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json_response['data'].first['id']).to eq(user_id)
    end
  end

  describe 'GET #show' do
    let(:headers) { { 'Authorization' => user_list.first.auth_token } }
    before do
      request.headers.merge!(headers)
      get :show, params: { id: user_id }
    end

    context 'the data is exist' do
      it 'returns a specific user' do
        json_response = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json_response['data']['id']).to eq(user_id)
      end
    end

    context 'the data is not exist' do
      let(:user_id) { 999 }
      it 'returns not found' do
        json_response = JSON.parse(response.body)
        expect(response.status).to eq(404)
        expect(json_response['message']).to eq('Data not found')
      end
    end
  end

  describe 'POST #create' do
    context 'when the request is valid' do
      let(:valid_attributes) { { user: { name: 'John Doe' } } }

      before do
        post :create, params: valid_attributes
      end

      it 'creates a user' do
        json_response = JSON.parse(response.body)
        expect(response.status).to eq(201)
        expect(json_response['data']['name']).to eq('John Doe')
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { user: { email: 'john@doe.com' } } }

      before do
        post :create, params: invalid_attributes
      end

      it 'return 422' do
        expect(response.status).to eq(422)
      end
    end
  end
end
