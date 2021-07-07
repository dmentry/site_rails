class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :destroy, :show]

  # Предохранитель от потери авторизации в нужных экшенах
  after_action :verify_authorized, only: [:new, :create, :edit, :update, :destroy]

  # GET /articles
  def index
    @articles = Article.all.order(created_at: :asc)
  end

  # GET /articles/1
  def show
    # Болванка коммента для формы добавления
    @new_comment = @article.comments.build
  end

  # GET /articles/new
  def new
    @article = Article.new

    authorize @article
  end

  # GET /articles/1/edit
  def edit
    authorize @article
  end

  # POST /articles
  def create
    @article = Article.new(article_params)

    authorize @article

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    authorize @article

    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    authorize @article

    @article.destroy

    redirect_to root_path, notice: ('Статья удалена')
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:article_title, :article_body)
  end
end
