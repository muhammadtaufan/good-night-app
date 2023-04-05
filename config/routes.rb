Rails.application.routes.draw do
  namespace :v1 do
    resources :users, except: %i[destroy] do
      resources :time_events

      member do
        post :follow, to: 'follows#create'
        delete :unfollow, to: 'follows#destroy'
      end
    end
  end
end
