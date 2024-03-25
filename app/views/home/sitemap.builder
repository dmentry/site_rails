xml.instruct! :xml, :version => "1.0", :encoding=>"UTF-8"
xml.urlset(:xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9") {

  xml.url {
    xml.loc("https://dack9.ru/ru/cv_rus")
  }

  xml.url {
    xml.loc("https://dack9.ru/en/cv_eng")
  }

  xml.url {
    xml.loc("https://dack9.ru/ru/map")
  }

  xml.url {
    xml.loc("https://dack9.ru/en/map")
  }

  xml.url {
    xml.loc("https://dack9.ru/ru/abouts/#{ @about.id }")
  }

  xml.url {
    xml.loc("https://dack9.ru/en/abouts/#{ @about.id }")
  }

  @articles.each do |article|
    xml.url {
      xml.loc("https://dack9.ru/ru/articles/#{ article.id }")
    }

    xml.url {
      xml.loc("https://dack9.ru/en/articles/#{ article.id }")
    }
  end

  @photos.each do |photo|
    xml.url {
      xml.loc("https://dack9.ru/uploads/photo/photo/#{ photo.id }/#{ photo.photo }")
    }
  end
}
