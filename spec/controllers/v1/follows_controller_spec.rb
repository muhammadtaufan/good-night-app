require 'rails_helper'

RSpec.describe V1::FollowsController, type: :controller do
  let!(:user_list) { create_list(:user, 3) }
  let(:headers) { { 'Authorization' => user_list.first.auth_token } }

  describe 'POST #create, followed a user' do
    before do
      request.headers.merge!(headers)
    end

    it 'returns success message' do
      post :create, params: { id: user_list.second.id }

      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('User followed')
      expect(json_response['success']).to be_truthy
    end

    context 'already followed' do
      before do
        user_list.first.follow(user_list.second)
      end

      it 'returns error message if ' do
        post :create, params: { id: user_list.second.id }
        json_response = JSON.parse(response.body)

        expect(json_response['message']).to eq('Already following this user')
        expect(json_response['success']).to be_falsey
      end
    end
  end

  describe 'DELETE #destroy, unfollow a user' do
    before do
      request.headers.merge!(headers)
    end

    it 'returns success message' do
      delete :destroy, params: { id: user_list.second.id }

      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('User unfollowed')
      expect(json_response['success']).to be_truthy
    end
  end
end
