# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:time_events) }
    it { should have_many(:follows).with_foreign_key('follower_id').dependent(:destroy) }
    it { should have_many(:followed_users).through(:follows).source(:followed) }
    it { should have_many(:followed).with_foreign_key('followed_id').class_name('Follow').dependent(:destroy) }
    it { should have_many(:followers).through(:followed).source(:follower) }
  end

  describe 'validate' do
    it { should validate_presence_of(:name) }
  end

  describe '#follow' do
    let(:me) { create(:user) }
    let(:my_friend) { create(:user) }

    context 'when not following yet' do
      it 'follows the user and returns a success message' do
        result = me.follow(my_friend)
        expect(result).to eq('User followed')
        expect(me.following?(my_friend)).to be_truthy
      end
    end

    context 'when already following the user' do
      before { me.follow(my_friend) }

      it 'returns an error message' do
        result = me.follow(my_friend)
        expect(result).to eq('Already following this user')
      end
    end
  end

  describe '#unfollow' do
    let(:me) { create(:user) }
    let(:my_friend) { create(:user) }

    before { me.follow(my_friend) }

    it 'unfollows the user' do
      me.unfollow(my_friend)
      expect(me.following?(my_friend)).to be_falsey
    end
  end

  describe '#following?' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context 'when following the user' do
      before { user.follow(other_user) }

      it 'returns true' do
        expect(user.following?(other_user)).to be_truthy
      end
    end

    context 'when not following the user' do
      it 'returns false' do
        expect(user.following?(other_user)).to be_falsey
      end
    end
  end

  # describe '#generate_auth_token' do
  #   let(:user) { build(:user) }

  #   it 'generates a unique auth token' do
  #     expect(user.auth_token).to be_nil
  #     user.save!
  #     expect(user.auth_token).not_to be_nil
  #     expect(User.exists?(auth_token: user.auth_token)).to be_truthy
  #   end
  # end
end
