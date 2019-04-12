class SessionsController < ApplicationController

    before_action :no_user_login_again, only:  [:new,:create]

    def new
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:username], params[:user][:password])

        if @user
            login_user!(@user)
            redirect_to cats_url
        else
            flash[:errors] = @user.errors.full_messages
            redirect_to new_session_url
        end

    end

    def destroy
        #logout
        current_user.reset_session_token!
        current_user = nil
        session[:session_token] = nil
        redirect_to cats_url
    end


end
