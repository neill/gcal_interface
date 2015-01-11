class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:google_oauth2]

    def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
        data = access_token.info
        #if (User.admins.include?(data.email))
            user = User.find_by(email: data.email)
            if user
                user.provider = access_token.provider
                user.uid = access_token.uid
                user.token = access_token.credentials.token
                user.save
                user
            else
                user = User.new(
                #name: access_token.extra.raw_info.name,
                email: data.email ? data.email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
                password: Devise.friendly_token[0,20],
                provider: access_token.provider,
                uid: access_token.uid,
                token: access_token.credentials.token
                )
                #user.skip_confirmation!
                user.save!
                user
                #redirect_to new_user_registration_path, notice: "Error."
            end
        #end
    end
end
