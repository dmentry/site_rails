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

  def cv_rus
    I18n.locale = :ru
    render layout: 'cv_layout'
  end

  def cv_eng
    I18n.locale = :en
    render layout: 'cv_layout'
  end

  def portfolio
    render 'abouts/portfolio/portfolio', layout: 'cv_layout'
  end

  def portfolio_case
    base_directory = "#{ Rails.root }/app/javascript/images/portfolio/"
    user_directory = params[:images_path]

    unless user_directory.match?(/\A[a-zA-Z]+\z/)
      redirect_to portfolio_path, notice: ('Что-то пошло не так 1')
      return
    end

    allowed_directories = ['arhtextile', 'kukumberryx', 'trainings', 'cloud', 'landing', 'photosite']

    unless allowed_directories.include?(user_directory)
      redirect_to portfolio_path, notice: ('Что-то пошло не так 2')
      return
    end

    full_path = File.expand_path(user_directory, base_directory)

    @images_path = user_directory

    file_count = Dir.glob(File.join(full_path, '*')).count { |file| File.file?(file) }

    if file_count <= 0
      redirect_to portfolio_path, notice: ('Что-то пошло не так 3')
      return
    end

    @all_ps_images_qnt = file_count - 1

    allowed_colors = ['light', 'dark']

    unless allowed_colors.include?(params[:bg_color])
      redirect_to portfolio_path, notice: ('Что-то пошло не так 4')
      return
    end

    @bg_color = params[:bg_color]

    if params[:label].present? && !params[:label].match?(/\A[\w\s]+\z/)
      redirect_to portfolio_path, notice: ('Что-то пошло не так 5')
      return
    end

    @label = if params[:label].present?
               params[:label]
             else
               user_directory.capitalize
             end

    @dark_body = if @bg_color == 'dark'
                   'dark_body'
                 else
                   ''
                 end

    render 'abouts/portfolio/portfolio_case', layout: 'cv_layout'
  end

  private

  def set_about
    @about = About.find(params[:id])
  end

  def about_params
    params.require(:about).permit(:main_text_ru, :main_text_en)
  end
end
