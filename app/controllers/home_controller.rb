class HomeController < ApplicationController
  def rss_feed
    @new_article = Article.where(new_rec: true)&.first

    @new_photo = Photo.where(new_rec: true)&.first

    respond_to do |format|
      format.rss
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

  def announces
    articles  = Article.order(created_at: :desc)
    photos    = Photo.without_photohosting.order(created_at: :desc)
    announces = (articles + photos).sort_by(&:created_at).reverse

    @pagy, @announces = pagy_array(announces, items: 10)
  end

  def searching
    if params[:q] && !params[:q].present?
      flash.now[:alert] = 'Введите поисковую фразу!'
      render :searching, status: :unprocessable_entity
    end

    if params[:q]
      q = params[:q]

      articles = Article.ransack(article_body_ru_or_article_body_en_or_article_title_ru_or_article_title_ru_cont: q).result
      photos   = Photo.ransack(description_ru_or_description_en_cont: q).result
      about    = About.ransack(main_text_ru_or_dmain_text_en_cont: q).result

      @results = if params[:sorting] && params[:sorting] == 'up'
                  (articles + photos + about).sort_by(&:created_at)
                 elsif params[:sorting] && params[:sorting] == 'down'
                  (articles + photos + about).sort_by(&:created_at).reverse
                 else
                  (articles + photos + about)
                 end
    end
  end
end
