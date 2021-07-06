class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :destroy, :show]

  # GET /articles
  def index
    @articles = Article.all
  end

  # GET /articles/1
  def show
    # Болванка коммента для формы добавления
    @new_comment = @article.comments.build
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    message = { notice: I18n.t('Комментарий удален') }

    if user_signed_in?
      @article.destroy
    else
      message = { alert: I18n.t('Вам такое нельзя!') }
    end

    redirect_to root_path, message
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:article_title, :article_body)
  end
end
