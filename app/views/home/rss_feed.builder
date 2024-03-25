xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title t('app.tab')

    if @new_article.present?
      xml.description t('app.rss.new_photo')
      xml.link articles_url

      xml.item do
        xml.title @new_article.article_title
        xml.description raw(@new_article.article_body[0..53])
        xml.pubDate @new_article.created_at.strftime("%d.%m.%Y")
        xml.link article_url(@new_article)
      end
    end

    if @new_photo.present?
      xml.description t('app.rss.new_photo')
      xml.link root_url

      xml.item do
        xml.title @new_photo.description
        xml.pubDate @new_photo.created_at.strftime("%d.%m.%Y")
        xml.link photo_url(@new_photo)
      end
    end
  end
end
