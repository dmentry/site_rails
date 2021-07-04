class PhotosController < ApplicationController
  # before_action :set_user, only: [:create, :destroy]
  # before_action :authenticate_user!, except: [:show, :index]
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos
  def index
    @photos = Photo.order(created_at: :desc).limit(5)

    @types = Type.select(:photo_type)

    @header = 'Недавние'

    render :universal_page
  end

  # GET /photos/1
  def show
  end

  # GET /photos/new
  def new
    if user_signed_in?
      @photo = Photo.new
    else
      redirect_to(:root, alert: "Это нельзя!")
    end
  end

  # GET /photos/1/edit
  def edit
    redirect_to(:root, alert: "Это нельзя!") unless user_signed_in?
  end

  # POST /photos
  def create
    @photo = Photo.new(photo_params)

    @photo.user = current_user

    if @photo.save
      # redirect_to @photo, notice: "Photo was successfully created."
      redirect_to :root, notice: "Photo was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /photos/1
  def update
    if @photo.update(photo_params)
      redirect_to :root, notice: "Photo was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /photos/1
  def destroy
    if user_signed_in?
      @photo.destroy

      redirect_to photos_url, notice: "Photo was successfully destroyed."
    else
      redirect_to(:root, alert: "Это нельзя!")
    end
  end

  #страницы категорий фоток
  def all_page
    @photos = Photo.all

    @header = 'Все'

    render :universal_page
  end

  def macro_page
    @photos = Photo.where(type_id: 1)

    @header = 'Макро'

    render :universal_page
  end

  def landscape_page
    @photos = Photo.where(type_id: 2)

    @header = 'Пейзажи'

    render :universal_page
  end

  def portrait_page
    @photos = Photo.where(type_id: 3)

    @header = 'Портреты'

    render :universal_page
  end

  def drone_page
    @photos = Photo.where(type_id: 4)

    @header = 'С квадрокоптера'

    render :universal_page
  end

  def collage_page
    @photos = Photo.where(type_id: 5)

    @header = 'Коллажи'

    render :universal_page
  end

  def other_page
    @photos = Photo.where(type_id: 6)

    @header = 'Остальное'

    render :universal_page
  end

  def about_page
  end

  def blog_page
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_photo
    @photo = Photo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def photo_params
    params.require(:photo).permit(:photo, :description, :type_id, :recent)
  end
end
