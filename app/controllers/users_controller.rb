class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update ]

  # GET /users/1 or /users/1.json
  def show
    authorize @user
    # current_user
  end

  # GET /users/1/edit
  def edit
    authorize @user
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    authorize @user

    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
