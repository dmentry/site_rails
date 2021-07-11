class CommentsController < ApplicationController
  before_action :set_article, only: [:create, :destroy]

  before_action :set_comment, only: [:destroy]

  # POST /comments
  def create
    @new_comment = @article.comments.build(comment_params)

    if check_captcha(@new_comment) && @new_comment.save
      redirect_to @article, notice: "Comment was successfully created."
    else
      render 'articles/show', alert: I18n.t('Комментарий добавить не удалось!')
    end
  end

  # DELETE /comments/1
  def destroy
    authorize @comment

    @comment.destroy

    redirect_to @article, notice: ('Коммент удален')
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment_body)
  end
end
