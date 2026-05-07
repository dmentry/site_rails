class PhotosController < ApplicationController
  # require 'RMagick'
  before_action :set_photo, only: [:show, :edit, :update, :destroy, :ym_balloon_data]

  # Предохранитель от потери авторизации в нужных экшенах
  after_action :verify_authorized, only: [:new, :create, :edit, :update, :destroy, :all_page]

  attr_accessor :feedback_email, :feedback_text

  # GET /photos
  def index
    kinds = Photo.kinds.keys + ['all', 'recent']

    redirect_to :root if !kinds.include?(params[:page_name])

    @nav_menu_active_item = 'photos'

    if params[:page_name] == 'all'
      @pagy, @photos = pagy(Photo.order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)

      @header = t('enums.photo.kind.all')

      authorize @photos
    elsif params[:page_name] == 'photohosting'
      @header = t('enums.photo.kind.photohosting')

      @pagy, @photos = pagy(Photo.where(kind: :photohosting).order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)

      authorize @photos
    elsif params[:page_name] == 'macro'
      @header = t('enums.photo.kind.macro')

      @pagy, @photos = pagy(Photo.where(kind: :macro).order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)
    elsif params[:page_name] == 'landscape'
      @header = t('enums.photo.kind.landscape')

      @pagy, @photos = pagy(Photo.where(kind: :landscape).order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)
    elsif params[:page_name] == 'portrait'
      @header = t('enums.photo.kind.portrait')

      @pagy, @photos = pagy(Photo.where(kind: :portrait).order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)
    elsif params[:page_name] == 'drone'
      @header = t('enums.photo.kind.drone')

      @pagy, @photos = pagy(Photo.where(kind: :drone).order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)
    elsif params[:page_name] == 'collage'
      @header = t('enums.photo.kind.collage')

      @pagy, @photos = pagy(Photo.where(kind: :collage).order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)
    elsif params[:page_name] == 'other'
      @header = t('enums.photo.kind.other')

      @pagy, @photos = pagy(Photo.where(kind: :other).order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)
    elsif params[:page_name] == 'recent'
      @header = t('enums.photo.kind.recent')

      @pagy, @photos = pagy(Photo.without_photohosting.order(created_at: :desc).limit(10).includes(:hashtags).all.order(created_at: :desc), items: Photo::PHOTOS_ON_PAGE)
    else
      redirect_to :root
    end
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

    redirect_back(
        fallback_location: photos_path, # Куда перенаправить, если нет referer
        notice: t('controllers.photos.destroy.success')
    )
  end

  def map
    @nav_menu_active_item = 'nav_map'

    marks             = {}
    marks['type']     = 'FeatureCollection'
    marks['features'] = []

    out = {}

    photo_id = params[:photo_id] if params[:photo_id].present? && params[:photo_id].match?(/\A\d+\z/)

    if photo_id.present?
      photo_zoomed = Photo.where(id: photo_id).first

      marks['photo_zoomed_coordinates'] = [photo_zoomed&.lat, photo_zoomed&.long] if photo_zoomed.present?
    end

    photos = Photo.where.not(lat: [nil, false, ''], long: [nil, false, ''])

    if photos.size > 0
      photos.each do |photo|
        popup_content = <<-STR
          <a target='_blank' rel='nofollow' class='article_title_link' href='#{ photo_path(photo) }'>
            <div class='custom-popup'>
              <div style='width:100px; font-size:80%; color:black;'>
                #{ photo.description }
              </div>
              <img style='width: 100px; border-radius: 5px;' alt='Фото' src='#{ photo.photo.thumb.url }'>
            </div>
          </a>
        STR

        marks['features'] << {
                              type: 'Feature',
                              id: photo.id,
                              geometry: { type: 'Point', coordinates: [photo.lat, photo.long] },
                              properties: { popup_content: popup_content },
                             }
      end

      out.merge!({ marks: marks })

      @show_marks = out.values.first
    else
      redirect_to :root, alert: 'Something goes wrong'
    end
  end

  private

  def set_photo
    @photo = Photo.where(id: params[:id]).first

    redirect_to :root if !@photo
  end

  def photo_params
    params.require(:photo).permit(
      :photo, :description_ru, :description_en, :body_ru, 
      :body_en, :type_id, :lat, :long, :photo_id, 
      :one_string_coordinates, :hashtag_names, :kind
    )
  end
end
