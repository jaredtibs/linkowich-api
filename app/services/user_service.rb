require './lib/json_web_token.rb'

class UserService
  class << self

    def generate_token_for(user)
      JsonWebToken.encode({
        user_id: user.id,
        email: user.email
      })
    end

    def send_reset_password_instructions(user)
      token_raw, token_enc = Devise.token_generator.generate(
        User, :reset_password_token
      )
      user.reset_password_token = token_enc
      user.reset_password_sent_at = Time.now
      user.save

      token_raw
    end

    def update_password(user, params)
      if user.reset_password_period_valid?
        if user.reset_password params[:password], params[:password_confirmation]
          token = generate_token_for user
          {result: { success: token } }
        else
          {result: { errors: "error updating password" } }
        end
      else
        {result: { errors: "reset password token expired" } }
      end
    end

  end
end
