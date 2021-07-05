class PhotosController < ApplicationController
  # before_action :set_user, only: [:create, :destroy]
  # before_action :authenticate_user!, except: [:show, :index]
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos
  def index
    @photos = Photo.order(created_at: :desc).limit(5)

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

  #страницы
  def all_page
    @photos = Photo.all

    @header = 'Все'

    render :universal_page
  end

  def macro_page
    # @photos = Photo.where(type_id: 1)

    # @photos = Photo.photos_by_type(1)

    # @header = 'Макро'

    @photos, @header = photo_types_arr(1)

    render :universal_page
  end

  def landscape_page
    @photos, @header = photo_types_arr(2)

    render :universal_page
  end

  def portrait_page
    @photos, @header = photo_types_arr(3)

    render :universal_page
  end

  def drone_page
    @photos, @header = photo_types_arr(4)

    render :universal_page
  end

  def collage_page
    @photos, @header = photo_types_arr(5)

    render :universal_page
  end

  def other_page
    @photos, @header = photo_types_arr(6)

    render :universal_page
  end

  def about_page
  end

  def blog_page
  end

  def feedback_page
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
