Rails.application.routes.draw do
root 'products#index'
'products#create'
resources :products
end
