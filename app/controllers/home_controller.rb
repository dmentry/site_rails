class HomeController < ApplicationController
  def rss_feed
    @new_article = Article.where(new_rec: true)&.first

    @new_photo = Photo.where(new_rec: true)&.first

    respond_to do |format|
      format.rss
    end
  end

  def announces
    @nav_menu_active_item = 'main'

    articles  = if current_user.present?
                 Article.all
               else
                 Article.where(is_visible: true)
               end

    articles  = articles.order(created_at: :desc)
    photos    = Photo.without_photohosting.order(created_at: :desc)
    announces = (articles + photos).sort_by(&:created_at).reverse

    @pagy, @announces = pagy_array(announces, items: 10)
  end

  def searching
    if params[:q] && !params[:q].present?
      flash.now[:alert] = t('views.searching.enter_search_phrase')

      render :searching, status: :unprocessable_entity
    end

    if params[:q]
      q = params[:q]

      articles = Article.ransack(article_body_ru_or_article_body_en_or_article_title_ru_or_article_title_ru_cont: q).result
      photos   = Photo.ransack(description_ru_or_description_en_cont: q).result
      about    = About.ransack(main_text_ru_or_main_text_en_cont: q).result

      @results = if params[:sorting] && params[:sorting] == 'up'
                  (articles + photos + about).sort_by(&:created_at)
                 elsif params[:sorting] && params[:sorting] == 'down'
                  (articles + photos + about).sort_by(&:created_at).reverse
                 else
                  (articles + photos + about)
                 end
    end
  end

  def feedback_page
    @nav_menu_active_item = 'nav_feedback'

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

  def sitemap
    @about    = About.first
    @articles = Article.all.order(created_at: :desc)
    @photos   = Photo.without_photohosting

    respond_to do |format|
      format.xml
    end
  end

  def by_hashtag
    if !params[:q].present?
      redirect_to root_path, alert: 'Вы не нажали на хэштег'

      return
    end

    @q = params[:q]

    articles  = if current_user.present?
                 Article.all
               else
                 Article.where(is_visible: true)
               end

    articles = articles.ransack(hashtags_name_eq: @q).result

    photos  = if current_user.present?
                Photo.all
              else
                Photo.without_photohosting
              end

    photos = photos.ransack(hashtags_name_eq: @q).result

    results = (articles + photos).sort_by(&:created_at).reverse

    @pagy, @results = pagy_array(results, items: 10)

    @nav_menu_active_item = 'photos'
  end

  private

  def feedback_params
    params.require(:feedback).permit(:feedback_email, :feedback_body)
  end
end
