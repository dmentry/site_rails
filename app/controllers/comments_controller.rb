class CommentsController < ApplicationController
  before_action :set_article, only: [:create, :destroy]

  before_action :set_comment, only: [:destroy]

  # POST /comments
  def create
    @new_comment = @article.comments.build(comment_params)

    @new_comment.current_user = current_user

    if current_user.present?
      @new_comment.comment_email = Rails.application.credentials.dig(Rails.env.to_sym, :mail, :default_to)
      @new_comment.user_id = current_user.id

      if @new_comment.save
        redirect_to @article, notice: t('controllers.comments.success_creation')
      else
        flash.now[:alert] = t('controllers.comments.failed_creation')

        render 'articles/show'
      end
    else
      if verify_recaptcha(model: @new_comment) && @new_comment.save
      # if @new_comment.save
        redirect_to @article, notice: t('controllers.comments.success_creation')
      else
        flash.now[:alert] = t('controllers.comments.failed_creation')

        render 'articles/show'
      end
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

    @new_comment.current_user = current_user

    if current_user.present?
      @new_comment.comment_email = Rails.application.credentials.dig(Rails.env.to_sym, :mail, :default_to)
      @new_comment.user_id = current_user.id

      if @new_comment.save
        send_email_to_comment = @new_comment.opinion_id

        article = Article.where(id: @new_comment.article_id).first

        comment = @new_comment.comment_body.strip

        locale = if params[:locale] == 'ru' || params[:locale] == nil
                   'ru'
                 else
                   'en'
                 end

        if send_email_to_comment.present? && article.present? && comment.present?
          article_full_link = article_url(article)

          SendMailService.call(
            send_email_to_comment: send_email_to_comment, 
            article_full_link: article_full_link,
            comment: comment,
            locale: locale
          )
        end

        redirect_to article_path(@new_comment.article_id), notice: t('controllers.comments.success_creation')
      else
        flash.now[:alert] = t('controllers.comments.failed_creation')

        render :answer_comment_new, status: :unprocessable_entity
      end
    else
      if verify_recaptcha(model: @new_comment) && @new_comment.save
        send_email_to_comment = @new_comment.opinion_id

        article = Article.where(id: @new_comment.article_id).first

        comment = @new_comment.comment_body.strip

        locale = if params[:locale] == 'ru' || params[:locale] == nil
                   'ru'
                 else
                   'en'
                 end

        if send_email_to_comment.present? && article.present? && comment.present?
          article_full_link = article_url(article)

          SendMailService.call(
            send_email_to_comment: send_email_to_comment, 
            article_full_link: article_full_link,
            comment: comment,
            locale: locale
          )
        end

      # if @new_comment.save
        redirect_to article_path(@new_comment.article_id), notice: t('controllers.comments.success_creation')
      else
        flash.now[:alert] = t('controllers.comments.failed_creation')

        render :answer_comment_new, status: :unprocessable_entity
      end
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
