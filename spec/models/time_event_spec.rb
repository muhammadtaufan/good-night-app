# spec/models/time_event_spec.rb
require 'rails_helper'

RSpec.describe TimeEvent, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:event_time) }
  end

  describe '#wake_up?' do
    it 'returns true if is_time_in is false' do
      time_event = TimeEvent.new(is_time_in: false)
      expect(time_event.wake_up?).to eq true
    end
  end

  describe '#sleep_time?' do
    it 'returns true if is_time_in is true' do
      time_event = TimeEvent.new(is_time_in: true)
      expect(time_event.sleep_time?).to eq true
    end
  end

  describe 'wake up time validation' do
    let!(:user) { create(:user) }

    it 'returns an error if the wake up time didnt have sleep time' do
      wake_up_time = build(:time_event, user: user, is_time_in: false)
      wake_up_time.save

      expect(wake_up_time).to_not be_valid
    end
  end
end
