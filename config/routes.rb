Rails.application.routes.draw do

  devise_for :users

  resources :posts

  get 'user_posts/:user_id' => 'posts#user', as: :user_posts

  root "posts#index"

end
