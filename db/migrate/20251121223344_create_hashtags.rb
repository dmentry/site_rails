class CreateHashtags < ActiveRecord::Migration[6.0]
  def change
    create_table :hashtags do |t|
      t.string :name, null: false
      t.timestamps
    end
    
    add_index :hashtags, :name, unique: true

    hss = ['ставропольский_край', 'краснодарский_край', 'адыгея', 'сочи', 'красная_поляна', 'кабардино_балкария', 'нагой_кош', 'кисловодск', 'анапа', 'туапсе', 'абрау_дюрсо', 'лаго_наки', 'пермский_край', 'краснодар', 'никола_ленивец', 'владивосток', 'новороссийск', 'геленджик', 'финский_залив', 'казань', 'самарская_область', 'нидерланды', 'германия', 'таиланд', 'турция', 'африка', 'тунис', 'пейзаж', 'горы', 'природа', 'море', 'закат', 'лето', 'зима', 'макрофотография', 'муха', 'ночь', 'ночная_фотография', 'длинная выдержка', 'город', 'водопад', ' маяк', ' заброшенное', 'техноген', 'фотошоп', 'портрет', 'разное', 'масштаб_h0', 'парк_галицкого', 'радиоуправляемые_модели', 'труба', 'обновление_сайта', 'железная_дорога', 'stavropol_region', 'krasnodar_region', 'adygeya', 'sotchi', 'krasnaya_polyana', 'kabardino_balkaria', 'nagoi_khosh', 'kislovodsk', 'anapa', 'tuapse', 'abrau_durso', 'lago_naki', 'perm_region', 'krasnodar', 'nikola_lenivets', 'vladivostok', 'novorossiysk', 'gelendzhik', 'finland_gulf', 'khazan', 'samara_region', 'netherlands', 'germany', 'thailand', 'turkey', 'africa', 'tunisia', 'landscape', 'mountains', 'nature', 'sea', 'sunset', 'summer', 'winter', 'macrophotography', 'fly', 'night', 'nightphotography', 'long_exposure', 'city', 'waterfall', 'lighthouse', 'abandoned', 'urban', 'photoshop', 'portrait', 'miscellaneous', 'scale_h0', 'galitsky_park', 'rc_models', 'rgt', 'mn78', 'factory_chimney', 'website_updates', 'railway']
  
    hss.each do |hs|
      Hashtag.create(name: hs)
    end
  end
end
