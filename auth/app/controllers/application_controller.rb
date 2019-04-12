class ApplicationController < ActionController::Base
    helper_method :current_user, :isLoggedIn?

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def login_user!(user)
        @current_user = user
        session[:session_token] = @current_user.reset_session_token!
    end
    
    def isLoggedIn?
        !!current_user
    end
    private
    def no_user_login_again
        redirect_to cats_url if isLoggedIn?
    end

    def ensure_logged_in
        redirect_to new_session_url if !isLoggedIn?
    end
end
