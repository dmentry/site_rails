class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # Предохранитель от потери авторизации в нужных экшенах
  after_action :verify_authorized, only: [:new, :create, :edit, :update, :destroy, :all_page]

  attr_accessor :feedback_email, :feedback_text

  # GET /photos
  def index
    @photos = Photo.order(created_at: :desc).limit(20)

    @header = t('controllers.photos.index.header')

    render :universal_page
  end

  # GET /photos/1
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new

    authorize @photo
  end

  # GET /photos/1/edit
  def edit
    authorize @photo
  end

  # POST /photos
  def create
    @photo = Photo.new(photo_params)

    @photo.user = current_user

    authorize @photo

    if @photo.save
      # redirect_to @photo, notice: "Photo was successfully created."
      redirect_to :root, notice: t('controllers.photos.create.success')
    else
      flash.now[:alert] = t('controllers.photos.create.fail')
      render :new
    end
  end

  # PATCH/PUT /photos/1
  def update
    authorize @photo

    if @photo.update(photo_params)
      redirect_to :root, notice: t('controllers.photos.update.success')
    else
      flash.now[:alert] = t('controllers.photos.update.fail')
      render :edit
    end
  end

  # DELETE /photos/1
  def destroy
    authorize @photo

    @photo.destroy!

    redirect_to photos_url, notice: t('controllers.photos.destroy.success')
  end

  #страницы
  def all_page
    @photos = Photo.all

    @header = t('controllers.photos.all_page.header')

    authorize @photos

    render :universal_page
  end

  def macro_page
    # @photos = Photo.where(type_id: 1)

    # @photos = Photo.photos_by_type(1)

    # @header = 'Макро'

    collect_photos_and_type(1)
  end

  def landscape_page
    collect_photos_and_type(2)
  end

  def portrait_page
    collect_photos_and_type(3)
  end

  def drone_page
    collect_photos_and_type(4)
  end

  def collage_page
    collect_photos_and_type(5)
  end

  def other_page
    collect_photos_and_type(6)
  end

  def about_page
  end

  def feedback_page
    @feedback = Feedback.new()
  end

  def feedback_page_send
    @feedback = Feedback.new(feedback_params)
    # if @feedback.valid?
    if verify_recaptcha(model: @feedback) && @feedback.valid?
      flash[:notice] = t('controllers.photos.feedback_page_send.success')

      FeedbackMailer.feedback_message(@feedback).deliver_now

      redirect_to :root
    else
      flash[:alert] = t('controllers.photos.feedback_page_send.fail')

      render :feedback_page
    end
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def collect_photos_and_type(type)
    @photos, @header = photos_and_type(type)

    render :universal_page
  end

  def photo_params
    params.require(:photo).permit(:photo, :description, :type_id)
  end

  def feedback_params
    params.require(:feedback).permit(:feedback_email, :feedback_body)
  end
end
