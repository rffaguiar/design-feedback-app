Rails.application.routes.draw do

  root 'static_pages#home'

  #override the admin devise controller to ours
  devise_for :admins, :controllers => {
    :sessions => 'admins/sessions'
  }

  get 'admin', to: 'admin/dashboard#index'

  # namespace all admin resources
  namespace :admin do
    resources :users, :designs, :comments, :spots
  end

  # override the user devise controller to ours
  devise_for :users, :controllers => {
    :sessions => 'users/sessions',
    :registrations => 'users/registrations',
    :passwords => 'users/passwords',
    :confirmations => 'users/confirmations'
  }

  get 'projetos', to: 'dynamic_pages#projetos'
  get 'individuais/minhas-imagens', to: 'dynamic_pages#individuais', as: :individuais
  get 'individuais/onde-comentei', to: 'dynamic_pages#my_comments', as: :my_comments
  post 'create_single', to: 'singles#create', as: :create_single

  # resources :users

  match 'contato', to: 'static_pages#contact', via: [:get, :post], as: :contact

  match 'a/create_comment', to: 'comments#create', via: [:post], as: :create_design_comment
  match 'a/delete_comment/:comment_id', to: 'comments#delete', via: [:delete], as: :delete_design_comment
  match 'a/delete_spot/:spot_id', to: 'spots#delete', via: [:delete], as: :delete_design_spot
  match 'delete_design/:design_id', to: 'singles#delete', via: [:delete], as: :delete_design

  match 'a/update_title', to: 'singles#update_title', via: [:patch], as: :update_design_title
  match 'a/update_subtitle', to: 'singles#update_subtitle', via: [:patch], as: :update_design_subtitle
  match 'a/feedback_app', to: 'singles#feedback_app', via: [:get], as: :feedback_app

  match ':design_link', to: 'singles#show', via: [:get], as: :design

end
