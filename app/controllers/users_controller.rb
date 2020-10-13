class UsersController < ApplicationController
    before_action :set_user, only: %i[show edit update destroy]
    before_action :require_user, only: %i[edit update]
    before_action :require_same_user, only: %i[edit update destroy]


    def show; end

    def index
        @user = User.all
    end
    
    def new
        @user = User.new
    end

    def edit; end

    def create
        @user = User.new(user_params)

        if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "Welcome to FORMS #{@user.username}, you have successfully signed up."
        redirect_to @user
        else
        render 'new'
        end
    end

    def update
        if @user.update(user_params)
            flash[:notice] = 'Your account information was successfully updated.'
            redirect_to @user
        else
            render 'edit'
        end
    end

    def destroy
        @user.destroy
        session[:user_id] = nil if @user == current_user
        flash[:notice] = 'Account and all associated articles successfully deleted.'
        redirect_to users_path
      end

    private
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def set_user
        @user = User.find(params[:id])
    end
    
    def require_same_user
    return unless current_user != @user && !current_user.admin?

    flash[:alert] = 'You can only edit or delete your own account.'
    redirect_to @user
    end
end
