Rails.application.routes.draw do
  get 'forecasts/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'forecasts#show'
end
