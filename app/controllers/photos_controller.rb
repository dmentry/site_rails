class PhotosController < ApplicationController
  # require 'RMagick'
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :ym_balloon_data]

  # Предохранитель от потери авторизации в нужных экшенах
  after_action :verify_authorized, only: [:new, :create, :edit, :update, :destroy, :all_page]

  attr_accessor :feedback_email, :feedback_text

  # GET /photos
  def index
    @nav_menu_active_item = 'photos'

    @photos = Photo.without_photohosting.order(created_at: :desc).limit(10)

    @header = t('controllers.photos.index.header')

    render :universal_page
  end

  # GET /photos/1
  def show
    @nav_menu_active_item = 'photos'
  end

  # GET /photos/new
  def new
    @nav_menu_active_item = 'photos'

    @photo = Photo.new

    authorize @photo
  end

  # GET /photos/1/edit
  def edit
    @nav_menu_active_item = 'photos'

    @photo.one_string_coordinates = if @photo.lat.present? && @photo.long.present?
                                      "#{ @photo.lat }, #{ @photo.long }"
                                    else
                                      ''
                                    end
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
    @nav_menu_active_item = 'photos'

    @pagy, @photos = pagy(Photo.order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)

    @header = t('controllers.photos.all_page.header')

    authorize @photos

    render :universal_page
  end

  def macro_page
    @nav_menu_active_item = 'photos'

    type_id = Type.where(photo_type: 'macro').first.id
    collect_photos_and_type(type_id)
  end

  def landscape_page
    @nav_menu_active_item = 'photos'

    type_id = Type.where(photo_type: 'landscape').first.id
    collect_photos_and_type(type_id)
  end

  def portrait_page
    @nav_menu_active_item = 'photos'

    type_id = Type.where(photo_type: 'portrait').first.id
    collect_photos_and_type(type_id)
  end

  def drone_page
    @nav_menu_active_item = 'photos'

    type_id = Type.where(photo_type: 'drone').first.id
    collect_photos_and_type(type_id)
  end

  def collage_page
    @nav_menu_active_item = 'photos'

    type_id = Type.where(photo_type: 'collage').first.id
    collect_photos_and_type(type_id)
  end

  def other_page
    @nav_menu_active_item = 'photos'

    type_id = Type.where(photo_type: 'other').first.id
    collect_photos_and_type(type_id)
  end

  def photohosting_page
    authorize Photo

    @nav_menu_active_item = 'photos'

    type_id = Type.where(photo_type: 'photohosting').first.id
    collect_photos_and_type(type_id)
  end

  def map
    @nav_menu_active_item = 'nav_map'

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
end
