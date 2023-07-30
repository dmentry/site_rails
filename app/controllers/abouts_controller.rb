class AboutsController < ApplicationController
  before_action :set_about, only: [:edit, :update, :destroy, :show]

  # Предохранитель от потери авторизации в нужных экшенах
  after_action :verify_authorized, only: [:index, :new, :create, :edit, :update, :destroy]

  def index
    @abouts = About.all
    authorize @abouts
  end

  def show
  end

  def new
    @about = About.new

    authorize @about
  end

  def edit
    authorize @about
  end

  def create
    @about = About.new(about_params)

    authorize @about

    if @about.save
      redirect_to @about, notice: "About was successfully created."
    else
      flash.now[:alert] = 'Текст не добавить не удалось!'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @about

    if @about.update(about_params)
      redirect_to @about, notice: "About was successfully updated."
    else
      flash.now[:alert] = 'Текст обновить не удалось!'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @about

    @about.destroy

    redirect_to root_path, notice: ('Текст удален')
  end

  private

  def set_about
    @about = About.find(params[:id])
  end

  def about_params
    params.require(:about).permit(:main_text_ru, :main_text_en)
  end
end
