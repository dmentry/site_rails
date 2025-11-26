class AnalyticsController < ApplicationController
  def get_data
    if request.remote_ip && !current_user
      data = {}

      data[:ip] = request.remote_ip

      result = GeocodingService.call(ip: request.remote_ip)

      if result[:country] && result[:region] && result[:city]
        data[:country]   = result[:country][:name_ru]
        data[:country_en]= result[:country][:name_en]
        data[:region]    = result[:region][:name_ru]
        data[:city]      = result[:city][:name_ru]
        data[:city_lat]  = result[:city][:lat]
        data[:city_long] = result[:city][:lon]
      end

      params[:visitor][:visitor_data].merge!(data)

                                                                                             # Игнорировать запросы от Googlebot
      AnalyticUpdater.call(params_visitor: params[:visitor]) if params[:visitor].present? && !data[:ip]&.start_with?('66.249.66.')
    end

    head :ok
  end

  def show_visitors_info
    @nav_menu_active_item = 'nav_admin'

    last_visited_dt = LastSeenVisitor&.last&.last_seen_visitors_dt

    @new_visitors_ids = Visitor.where('uniq_visitor=? AND created_at>?', true, last_visited_dt).ids

    @pagy, @visitors = pagy(Visitor.where(uniq_visitor: true).order(created_at: :desc), items: Visitor::VISITORS_ON_PAGE)

    LastSeenVisitor.create(last_seen_visitors_dt: Time.now)

    authorize @visitors
  end

  def show_visitor_info
    @nav_menu_active_item = 'nav_admin'

    source = Visitor.where(u_id: params[:u_id]).order(created_at: :desc)

    @pagy, @visitor = pagy(source, items: Visitor::VISITORS_ON_PAGE)

    @visitor_all_visits = source.count

    authorize @visitor
  end

  def show_visits
    @nav_menu_active_item = 'nav_admin'

############ Данные для посещений по месяцам и общие суммы ##################################
    all_visits_uniq = 0
    all_visits_repeat = 0
    uniq_visits_monthly = {}
    repeat_visits_monthly = {}
    overall_visits_monthly = {}

    Analytic.all.order(:id).each do |analytic|
      all_visits_uniq += analytic.uniq_visitor
      all_visits_repeat += analytic.repeat_visitor

      dt = "0#{ analytic.views_period_month }.#{ analytic.views_period_year }"
      uniq_visits_monthly[dt] = analytic.uniq_visitor
      repeat_visits_monthly[dt] = analytic.repeat_visitor
      overall_visits_monthly[dt] = uniq_visits_monthly[dt] + repeat_visits_monthly[dt]
    end

    @all_visits_uniq = all_visits_uniq
    @all_visits_repeat = all_visits_repeat

    uniq_visits_monthly = { data: uniq_visits_monthly, name: 'Уникальные посетители' }
    repeat_visits_monthly = { data: repeat_visits_monthly, name: 'Повторные посещения' }
    overall_visits_monthly = { data: overall_visits_monthly, name: 'Всего посещений' }

    @visits_monthly = [uniq_visits_monthly, repeat_visits_monthly, overall_visits_monthly]

    @countries = countries_data

############# Данные для посещений по регионам выбранной страны #############################
    @chosen_country = if params[:chosen_country].present?
                        params[:chosen_country]
                      else
                        if Visitor.where('uniq_visitor =? AND country =?', true, 'Россия')
                          'Россия'
                        else
                          Visitor.where(uniq_visitor: true).pluck(:country).last
                        end
                      end

    query_regions = <<-SQL
      SELECT visitors.region, COUNT(visitors.region) AS quantity
      FROM visitors 
      WHERE visitors.uniq_visitor = TRUE 
        AND visitors.country = '#{ @chosen_country }'
      GROUP BY visitors.region
      ORDER BY COUNT(visitors.region) DESC;
    SQL

    data_regions = ActiveRecord::Base.connection.execute(query_regions).to_a.flatten

    if data_regions.present?
      sourse_regions = {}

      data_regions.each { |datum| sourse_regions[datum['region']] = datum['quantity'] }

      @regions = { data: sourse_regions }
    end

############# Данные для посещений по городам выбранной страны  #############################
    query_cities = <<-SQL
      SELECT visitors.city, COUNT(visitors.city) AS quantity
      FROM visitors 
      WHERE visitors.uniq_visitor = TRUE 
        AND visitors.country = '#{ @chosen_country }'
      GROUP BY visitors.city
      ORDER BY COUNT(visitors.city) DESC;
    SQL

    data_cities = ActiveRecord::Base.connection.execute(query_cities).to_a.flatten

    if data_cities.present?
      sourse_cities = {}

      data_cities.each { |datum| sourse_cities[datum['city']] = datum['quantity'] }

      @cities = { data: sourse_cities}
    end
#############################################################################################

    if current_user
      authorize current_user

      respond_to do |format|
        format.js
        format.html { render 'show_visits' }
      end
    else
      user_not_authorized
    end
  end

  def are_new_visitors
    out = if params[:mega_secret_token] && params[:mega_secret_token] == (Date.today.day - 1).to_s(8)
            last_visited_dt = LastSeenVisitor&.last&.last_seen_visitors_dt

            new_uniq_visitors = Visitor.where('send_to_script=? AND uniq_visitor=? AND created_at>?', false, true, last_visited_dt)

            new_uniq_visitors_quantity = new_uniq_visitors.size

            if new_uniq_visitors_quantity > 0
              new_uniq_visitors.each do |v|
                v.update_column(:send_to_script, true)
              end

              { answer: new_uniq_visitors_quantity }
            end
          end

    respond_with out.to_json if out
  end

  def map_countries
    countries_to_show_data = countries_data(en: true)

    countries_to_show = countries_to_show_data.map { |item| item[:name] }

    countries_to_show = CountryShapeService.call(countries: countries_to_show)

    countries_to_show.compact!

    countries_to_show_data.each do |country_data|
      countries_to_show[country_data[:name]][:properties][:qnt] = country_data[:data]
    end

    @countries_to_show = countries_to_show.values
  end

  def coordinates_on_map
    @nav_menu_active_item = 'nav_admin'

    marks             = {}
    marks['type']     = 'FeatureCollection'
    marks['features'] = []

    out = {}

    coordinates_to_show = Visitor.select('DISTINCT ON (city_long, city_lat) *')

    coordinates_to_show.each do |coordinates|
      popup_content = <<-STR
        <div class='custom-popup'>
          <div style='width:220px; font-size:80%; color:black;'>
            Страна: <b>#{ coordinates.country }</b><br>
            Регион: <b>#{ coordinates.region }</b><br>
            Город: <b>#{ coordinates.city }</b><br>
            Координаты: <b>#{ coordinates.city_lat },  #{ coordinates.city_long }</b>
          </div>
        </div>
      STR

      marks['features'] << {
                             type: 'Feature',
                             geometry: { type: 'Point', coordinates: [coordinates.city_lat, coordinates.city_long] },
                             properties: { popup_content: popup_content },
                           }
    end

    out.merge!({ marks: marks })

    @show_marks = out.values.first
  end

  private

  def countries_data(en: nil)
    ############ Данные для посещений по странам ################################################

    country_language = if en
                         'country_en'
                       else
                         'country'
                       end

    query_countries = <<-SQL
      SELECT visitors.#{ country_language }, COUNT(visitors.#{ country_language }) AS quantity
      FROM visitors 
      WHERE visitors.uniq_visitor = TRUE 
        AND visitors.#{ country_language } IS NOT NULL
      GROUP BY visitors.#{ country_language }
      ORDER BY COUNT(visitors.#{ country_language }) DESC;
    SQL

    data_countries = ActiveRecord::Base.connection.execute(query_countries).to_a.flatten

    sourse_countries = []

    data_countries.each do |datum|
      country = {}
      country[:name] = datum[country_language]
      country[:data] = datum['quantity']

      sourse_countries << country
    end

    sourse_countries
  end
end
