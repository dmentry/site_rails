class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :destroy, :show]

  # Предохранитель от потери авторизации в нужных экшенах
  after_action :verify_authorized, only: [:new, :create, :edit, :update, :destroy]

  # GET /articles
  def index
    @nav_menu_active_item = 'blog'

    articles = if current_user.present?
                 Article.all
               else
                 Article.where(is_visible: true)
               end

    @pagy, @articles = pagy(articles.order(created_at: :desc), items: Article::ARTICLES_ON_PAGE)
  end

  # GET /articles/1
  def show
    authorize @article
    @nav_menu_active_item = 'blog'

    # Болванка коммента для формы добавления
    @new_comment = @article.comments.build
  end

  # GET /articles/new
  def new
    @article = Article.new

    authorize @article

    @nav_menu_active_item = 'blog'
  end

  # GET /articles/1/edit
  def edit
    authorize @article

    @nav_menu_active_item = 'blog'
  end

  # POST /articles
  def create
    @article = Article.new(article_params)

    old_new_article = Article.where(new_rec: true)&.first
    old_new_article.update_column(:new_rec, false) if old_new_article

    @article.new_rec = true

    authorize @article

    if @article.save
      redirect_to @article, notice: 'Запись добавлена успешно!'
    else
      flash.now[:alert] = 'Запись добавить не удалось!'
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    authorize @article

    if @article.update(article_params)
      redirect_to @article, notice: 'Запись обновлена успешно!'
    else
      flash.now[:alert] = 'Запись обновить не удалось!'
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    authorize @article

    @article.destroy

    redirect_to root_path, notice: ('Запись удалена')
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:article_title_ru, :article_body_ru, :article_title_en, :article_body_en, :is_visible)
  end
end
