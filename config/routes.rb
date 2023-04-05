Rails.application.routes.draw do
  namespace :v1 do
    resources :users, except: %i[create destroy] do
      resources :time_events
    end
  end
end
