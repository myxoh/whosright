class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :positions]
  before_action :only_admin, only: [:index, :destroy] #Only Administrators can list all users or destroy them
  before_action :get_user_or_redirect, only: [:show, :edit, :update, :by_email, :positions] #Only show the profiles to logged in users.
  before_action :config_email_disabled, only: [:edit, :update]
  before_action :user_match, only: [:edit, :update] # Only the user should have access to this content

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    show_user
  end
  
  def by_email
    @requested_user=User.find(User.find_by_email(params[:user][:email]).try(:id)) #Force 404 if user doesn't exist
    show_user
  end

  # GET /users/new
  def new  
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { log_in(@user,notice: "User was created successfully")}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(modify_user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @requested_user = User.find(params[:id])
    end
    def show_user
      respond_to do |format|
        format.html {render 'show'}
        format.json {render json: @requested_user}
      end
    end
    
    def config_email_disabled
      @config[:email_disabled] = true
    end
    
    def user_match
      (@requested_user==@user)? true : redirect_to(root_path,{flash:{error:"Not enough permissions to do this"}})
      #TODO user the already created match from UserPermissions
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
    
    def modify_user_params
      params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation)
    end
end
