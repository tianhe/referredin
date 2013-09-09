class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def linkedin
    auth = request.env["omniauth.auth"]
    @user = User.find_with_linkedin_oauth(auth) ||  User.create_with_linkedin_oauth(auth)

    Resque.enqueue LinkUsersJob, @user.id

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Linkedin") if is_navigational_format?
    else
      session["devise.linkedin_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
