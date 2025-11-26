class HashtagsController < ApplicationController
  before_action :set_hashtag, only: [:edit, :update, :destroy]

  def index
    @nav_menu_active_item = 'admin_options'

    hashtags = Hashtag.all.order(:name)

    authorize hashtags

    @hashtags_overall = hashtags.size

    @pagy, @hashtags = pagy(hashtags, items: 25)
  end

  def new
    @nav_menu_active_item = 'admin_options'

    @hashtag = Hashtag.new

    authorize @hashtag
  end

  def edit
    @nav_menu_active_item = 'admin_options'

    authorize @hashtag
  end

  def create
    @hashtag = Hashtag.new(hashtag_params)

    authorize @hashtag

    @nav_menu_active_item = 'admin_options'

    if @hashtag.save
      redirect_to hashtags_path, notice: "Хэштег был успешно создан."
    else
      render :edit, alert: "Хэштег не был создан."
    end
  end

  def update
    authorize @hashtag

    if @hashtag.update(hashtag_params)
      redirect_to hashtags_path, notice: "Хэштег был успешно изменен."
    else
      render :edit, alert: "Хэштег не был изменен."
    end
  end

  def destroy
    if @hashtag.destroy!
      message = { notice: 'Хэштег удален успешно.' }
    else
      message = { alert: 'Хэштег не был удален.' }
    end

    redirect_to hashtags_path, message
  end

  def index_autocomplete
    query = params[:q].to_s.strip
    
    if query.present?
      hashtags = Hashtag.where("name ILIKE ?", "%#{query}%").limit(20)
    else
      hashtags = Hashtag.order(:name).limit(500) # Для первоначальной загрузки
    end
    
    render json: hashtags.map { |h| { id: h.id, name: h.name } }
  end

  def cloud
    @nav_menu_active_item = 'hs_cloud'
  end

  def cloud_data
    # Получаем хэштеги с количеством использований через entity_hashtags
    hashtags_data = Hashtag.joins(:entity_hashtags)
                          .select('hashtags.*, COUNT(entity_hashtags.id) as usage_count')
                          .group('hashtags.id')
                          .having('COUNT(entity_hashtags.id) > 2')
                          .order('usage_count DESC')
                          .limit(200)

    current_locale = I18n.locale.to_s

    hashtags = hashtags_data.map do |hashtag|
      {
        name: hashtag.name,
        count: hashtag.usage_count,
        url: "/#{ current_locale }/by_hashtag?qq=#{ hashtag.name }"
      }
    end

    render json: hashtags
  end

  private

  def set_hashtag
    @hashtag = Hashtag.find(params[:id])
  end

  def hashtag_params
    params.require(:hashtag).permit(:name)
  end
end

