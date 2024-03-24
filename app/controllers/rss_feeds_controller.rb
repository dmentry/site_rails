class RssFeedsController < ApplicationController
  def rss_feed
    @new_article = Article.where(new_rec: true)&.first

    @new_photo = Photo.where(new_rec: true)&.first

    respond_to do |format|
      format.rss
    end
  end
end
