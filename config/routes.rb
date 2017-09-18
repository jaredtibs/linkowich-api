Rails.application.routes.draw do
  root to: "health#ping"
  get "/healthmonitor" => "health#ping"

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

        # following
        get    'user/followers'        => 'users#followers'
        get    'user/following'        => 'users#following'
        post   'user/follow/:code'     => 'users#follow_by_code'

        get    'user/links'       => 'users#links'
        get    'users/:username'  => 'users#show'

        # unused atm - TBD
        #post   'users/:username/follow' => 'users#follow'
        #delete 'users/:username/follow' => 'users#unfollow'

        # invitations

        # links (Feed)
        get    'links'    => 'links#feed'
        get    'links/me' => 'links#current'
        post   'links'    => 'links#create'
        delete 'links/me' => 'links#clear'
      end

    end
  end

end
