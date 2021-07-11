class CommentsController < ApplicationController
  before_action :set_article, only: [:create, :destroy]

  before_action :set_comment, only: [:destroy]

  # POST /comments
  def create
    @new_comment = @article.comments.build(comment_params)

    if verify_recaptcha(model: @new_comment) && @new_comment.save
    # if @new_comment.save
      redirect_to @article, notice: 'Comment was successfully created.'
    else
      flash.now[:alert] = 'Комментарий добавить не удалось!'
      render 'articles/show'
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
    params.require(:comment).permit(:comment_body, :comment_email)
  end
end
