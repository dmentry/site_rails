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
end
