class CommentsController < ApplicationController
  before_action :set_article, only: [:create, :destroy]

  before_action :set_comment, only: [:destroy]

  # POST /comments
  def create
    @new_comment = @article.comments.build(comment_params)

    if verify_recaptcha(model: @new_comment) && @new_comment.save
    # if @new_comment.save
      redirect_to @article, notice: t('controllers.comments.success_creation')
    else
      flash.now[:alert] = t('controllers.comments.failed_creation')

      render 'articles/show'
    end
  end

  # DELETE /comments/1
  def destroy
    authorize @comment

    @comment.destroy

    redirect_to @article, notice: ('Коммент удален')
  end

  def answer_comment_new
    if params[:article_id].nil?
      redirect_to articles_path

      return
    end

    @article = Article.find(params[:article_id])

    @comment_to_answer = Comment.find(params[:comment_id])

    @new_comment = Comment.new(article_id: @comment_to_answer.article_id, opinion_id: @comment_to_answer.id)
  end

  def create_answer_comment
    @new_comment = Comment.new(comment_params)

    if verify_recaptcha(model: @new_comment) && @new_comment.save
    # if @new_comment.save
      redirect_to Article.find(@new_comment.article_id), notice: t('controllers.comments.success_creation')
    else
      flash.now[:alert] = t('controllers.comments.failed_creation')

      render :answer_comment_new, status: :unprocessable_entity
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment_body, :comment_email, :comment_id, :article_id, :opinion_id)
  end
end
