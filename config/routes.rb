Rails.application.routes.draw do
  namespace :v1 do
    resources :users, except: %i[destroy] do

      member do
        post :follow, to: 'follows#create'
        delete :unfollow, to: 'follows#destroy'
      end
    end

    resources :time_events, only: %i[index show] do
      collection do
        get :weekly_time_summary, to: 'time_events#weekly_time_summary'
        post :sleep, to: 'time_events#sleep'
        post :wake_up, to: 'time_events#wake_up'
      end
    end
  end
end
