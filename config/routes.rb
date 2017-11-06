Rails.application.routes.draw do
  root to: "health#ping"
  get "/healthmonitor" => "health#ping"
  mount Sidekiq::Web => '/sidekiq'

  scope module: :api do
    scope module: :v1 do

      scope 'api/v1' do

        devise_for :users, skip: :all
        devise_scope :user do
          post   'registrations'  => 'registrations#create'
          post   'sessions'       => 'sessions#create'
          get    'sessions'       => 'sessions#show'
          delete 'sessions'       => 'sessions#destroy'
        end

        # users
        put  'user'            => 'users#update'
        put  'user/email'      => 'users#update_email'
        put  'reset-password'  => 'users#update_password'
        post 'user/avatar'     => 'users#update_avatar'
        post 'reset-password'  => 'users#reset_password'

        # follow relationships
        get    'user/followers'        => 'users#followers'
        get    'user/following'        => 'users#following'
        post   'user/follow/:code'     => 'users#follow_by_code'

        post   'users/:id/follow' => 'users#follow'
        delete 'users/:id/follow' => 'users#unfollow'

        # invitations
        post   'invitations'            => 'invitations#create'
        post   'invitations/:id/accept' => 'invitations#accept'
        get    'invitations'            => 'invitations#for_user'

        # links (Feed)
        get    'links'            => 'links#feed'
        get    'links/me'         => 'links#current'
        post   'links'            => 'links#create'
        post   'links/:id/vote'   => 'links#upvote'
        post   'links/:id/seen'   => 'links#mark_as_seen'
        delete 'links/me'         => 'links#clear'
        delete 'links/:id/vote'   => 'links#unvote'

        # profiles
        get    'users/:id'        => 'users#show'
        get    'users/:id/links'  => 'users#links'

      end

    end
  end

end
