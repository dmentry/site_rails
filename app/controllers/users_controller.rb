class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update ]

  def show
    authorize @user
    redirect_to announces_path
  end

  def edit
    authorize @user
    redirect_to announces_path
  end

  def update
    authorize @user
    redirect_to announces_path

    # if @user.update(user_params)
    #   redirect_to @user, notice: "User was successfully updated."
    # else
    #   render :edit, status: :unprocessable_entity
    # end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
