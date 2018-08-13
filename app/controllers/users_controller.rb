class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザー登録が完了しました'
      redirect_to @user
    else
      render 'new'
    end

    # respond_to do |format|
    #   if @user.save
    #     format.html { redirect_to @user, notice: 'User was successfully created.' }
    #     format.json { render :show, status: :created, location: @user }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to @user, flash: { success: 'User was successfully updated.' }
    else
      render :edit
    end
    # respond_to do |format|
    #   if @user.update_attributes(user_params)
    #     format.html { redirect_to @user, notice: 'User was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @user }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
    # respond_to do |format|
    #   format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
