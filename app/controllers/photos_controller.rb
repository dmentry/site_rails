class PhotosController < ApplicationController
  # require 'RMagick'
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :ym_balloon_data]

  # Предохранитель от потери авторизации в нужных экшенах
  after_action :verify_authorized, only: [:new, :create, :edit, :update, :destroy, :all_page]

  attr_accessor :feedback_email, :feedback_text

  # GET /photos
  def index
    @photos = Photo.without_photohosting.order(created_at: :desc).limit(10)

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
    @photo.one_string_coordinates = "#{ @photo.lat }, #{ @photo.long }"

    authorize @photo
  end

  # POST /photos
  def create
    @photo = Photo.new(photo_params)

    @photo.user = current_user

    old_new_photo = Photo.where(new_rec: true)&.first
    old_new_photo.update_column(:new_rec, false) if old_new_photo

    @photo.new_rec = true

    authorize @photo

# Читать координаты и записывать их, если есть
# img = Magick::Image.read(Rails.root.to_s + '/public/' + @photo.photo.thumb.url).first
# img['icc:copyright'] = '1111111'
# img.write(Rails.root.to_s + '/public/' + @photo.photo.thumb.url)

    if @photo.save
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
    @pagy, @photos = pagy(Photo.order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)

    @header = t('controllers.photos.all_page.header')

    authorize @photos

    render :universal_page
  end

  def macro_page
    # @photos = Photo.where(type_id: 1)

    # @photos = Photo.photos_by_type(1)

    # @header = 'Макро'

    type_id = Type.where(photo_type: 'macro').first.id
    collect_photos_and_type(type_id)
  end

  def landscape_page
    type_id = Type.where(photo_type: 'landscape').first.id
    collect_photos_and_type(type_id)
  end

  def portrait_page
    type_id = Type.where(photo_type: 'portrait').first.id
    collect_photos_and_type(type_id)
  end

  def drone_page
    type_id = Type.where(photo_type: 'drone').first.id
    collect_photos_and_type(type_id)
  end

  def collage_page
    type_id = Type.where(photo_type: 'collage').first.id
    collect_photos_and_type(type_id)
  end

  def other_page
    type_id = Type.where(photo_type: 'other').first.id
    collect_photos_and_type(type_id)
  end

  def photohosting_page
    authorize Photo

    type_id = Type.where(photo_type: 'photohosting').first.id
    collect_photos_and_type(type_id)
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

  def map
    marks             = {}
    marks['type']     = 'FeatureCollection'
    marks['features'] = []

    out = {}

    session[:photo_id] = params[:photo_id] if params[:photo_id].present? && params[:photo_id].match?(/\A\d+\z/)

    photos = if request.format.json? && session[:photo_id].present?
                tmp = Photo.where(id: session[:photo_id])
                out.merge!({ photo_id: session[:photo_id] })
                session[:photo_id] = nil

                tmp
              else
                Photo.where('length(lat) > 0').where.not(lat: [nil, false])
              end

    photos.each do |photo|
      marks['features'] << {
                            type: 'Feature',
                            id: photo.id,
                            geometry: { type: 'Point', coordinates: [photo.lat, photo.long] },
                            properties: { hintContent: "#{ photo.description }" }
                           }
    end

    out.merge!({ marks: marks })

    respond_to do |format|
      format.html do
        respond_with nil
      end

      format.json do
        response.headers['Vary'] = 'Accept'
        respond_with out.to_json
      end
    end
  end

  def ym_balloon_data
    out               = {}
    out[:photo]       = "#{ 
                            ActionController::Base.helpers.link_to(
                              ActionController::Base.helpers.image_tag(
                                @photo.photo.thumb.url, style: 'width: 100px', alt: 'Фото'
                              ), photo_path(@photo), target: '_blank', rel: 'nofollow'
                            ) 
                          }"
    out[:description] = @photo.description

    respond_with out.to_json
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  def collect_photos_and_type(type)
    @pagy, @photos = photos_by_type(type)

    @header = photos_header(type)

    render :universal_page
  end

  def photo_params
    params.require(:photo).permit(:photo, :description_ru, :description_en, :type_id, :lat, :long, :photo_id, :one_string_coordinates)
  end

  def feedback_params
    params.require(:feedback).permit(:feedback_email, :feedback_body)
  end
end
