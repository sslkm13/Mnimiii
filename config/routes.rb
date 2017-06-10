Rails.application.routes.draw do

  resources :posts do
    resources :comments
    member do
      get 'like'
      get 'unlike'
    end
  end

  get 'notifications/:id/link_through', to: 'notifications#link_through',
                                        as: :link_through

  get 'notifications', to: 'notifications#index'
  get 'profiles/show'
  get '/posts' => 'posts#index'


  devise_for :users, :controllers => { registrations: 'registrations' }

  root 'welcome#index'

  get ':user_name', to: 'profiles#show', as: :profile
  post ':user_name/edit', to: 'profiles#edit', as: :edit_profile
  patch ':user_name/edit', to: 'profiles#update', as: :update_profile
  get '/posts/hashtag/:name', to:'posts#hashtags'

   resources :friendships do
    member do
      post 'approve_friend', to: 'friendships#approve_friend'
      post 'request_friend', to: 'friendships#request_friend'
      delete 'remove_friend', to: 'friendships#remove_friend'
      post 'block_friend', to: 'friendships#block_friend'
      post 'unblock_friend', to: 'friendships#unblock_friend'
      post 'common_friends', to: 'friendships#common_friends'
    end
  end
end
