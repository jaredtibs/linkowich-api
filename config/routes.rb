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
        get  'users/:username' => 'users#show'
        get  'search/users'    => 'users#search'
        put  'user'            => 'users#update'
        put  'user/email'      => 'users#update_email'
        put  'reset-password'  => 'users#update_password'
        post 'user/avatar'     => 'users#update_avatar'
        post 'reset-password'  => 'users#reset_password'

        # following
        get    'user/followers'        => 'users#followers'
        get    'user/following'        => 'users#following'
        post   'user/follow/:code'     => 'users#follow_by_code'

        # unused atm - TBD
        #post   'user/follow/:username' => 'users#follow'
        #delete 'user/follow/:username' => 'users#unfollow'

        # invitations

        # links
        post   'links'    => 'links#create'
        get    'links'    => 'links#for_user'
        get    'links/me' => 'links#current'
        delete 'links/me' => 'links#clear'
      end

    end
  end

end
