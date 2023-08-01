class AnalyticsController < ApplicationController
  def get_data
    current_user_present = if current_user
                             true
                           else
                             false
                           end

    AnalyticUpdater.call(params_visitor: params[:visitor], current_user_present: current_user_present) if params[:visitor].present?

    head :ok
  end

  def show_visitors_info
    last_seen_visitors = LastSeenVisitor&.last&.last_seen_visitors_dt
    @last_seen_visitors_ids = Visitor.where('uniq_visitor=? AND created_at>?', true, last_seen_visitors).ids

    @pagy, @visitors = pagy(Visitor.where(uniq_visitor: true).order(created_at: :desc), items: Visitor::VISITORS_ON_PAGE)

    LastSeenVisitor.create(last_seen_visitors_dt: Time.now)

    authorize @visitors
  end

  def show_visitor_info
    source = Visitor.where(u_id: params[:u_id]).order(created_at: :desc)

    @pagy, @visitor = pagy(source, items: Visitor::VISITORS_ON_PAGE)

    @visitor_all_visits = source.count

    authorize @visitor
  end

  def show_visits
############ Данные для посещений по месяцам и общие суммы ##################################
    all_visits_uniq = 0
    all_visits_repeat = 0
    uniq_visits_monthly = {}
    repeat_visits_monthly = {}

    Analytic.all.each do |analytic|
      all_visits_uniq += analytic.uniq_visitor
      all_visits_repeat += analytic.repeat_visitor

      dt = "0#{ analytic.views_period_month }.#{ analytic.views_period_year }"
      uniq_visits_monthly[dt] = analytic.uniq_visitor
      repeat_visits_monthly[dt] = analytic.repeat_visitor
    end

    @all_visits_uniq = all_visits_uniq
    @all_visits_repeat = all_visits_repeat

    uniq_visits_monthly = { data: uniq_visits_monthly, name: 'Уникальные посетители' }
    repeat_visits_monthly = { data: repeat_visits_monthly, name: 'Повторные посещения' }

    @visits_monthly = [uniq_visits_monthly, repeat_visits_monthly]
#############################################################################################

############ Данные для посещений по странам ################################################
    query_countries = <<-SQL
      SELECT visitors.country, COUNT(visitors.country) AS quantity
      FROM visitors 
      WHERE visitors.uniq_visitor = TRUE 
        AND visitors.country IS NOT NULL
      GROUP BY visitors.country
      ORDER BY COUNT(visitors.country) DESC;
    SQL

    data_countries = ActiveRecord::Base.connection.execute(query_countries).to_a.flatten

    sourse_countries = []

    data_countries.each do |datum|
      country = {}
      country[:name] = datum['country']
      country[:data] = datum['quantity']

      sourse_countries << country
    end

    @countries = sourse_countries

############# Данные для посещений по регионам выбранной страны #############################
    chosen_country = 'Russia'

    query_regions = <<-SQL
      SELECT visitors.region, COUNT(visitors.region) AS quantity
      FROM visitors 
      WHERE visitors.uniq_visitor = TRUE 
        AND visitors.country = '#{ chosen_country }'
      GROUP BY visitors.region
      ORDER BY COUNT(visitors.region) DESC;
    SQL

    data_regions = ActiveRecord::Base.connection.execute(query_regions).to_a.flatten

    sourse_regions = []

    data_regions.each do |datum|
      region = {}
      region[:name] = datum['region']
      region[:data] = datum['quantity']

      sourse_regions << region
    end

    @regions = sourse_regions

############# Данные для посещений по городам выбранной страны  #############################

    query_cities = <<-SQL
      SELECT visitors.city, COUNT(visitors.city) AS quantity
      FROM visitors 
      WHERE visitors.uniq_visitor = TRUE 
        AND visitors.country = '#{ chosen_country }'
      GROUP BY visitors.city
      ORDER BY COUNT(visitors.city) DESC;
    SQL

    data_cities = ActiveRecord::Base.connection.execute(query_cities).to_a.flatten

    sourse_cities = []

    data_cities.each do |datum|
      city = {}
      city[:name] = datum['city']
      city[:data] = datum['quantity']

      sourse_cities << city
    end

    @cities = sourse_cities
#############################################################################################

    if current_user
      authorize current_user
    else
      user_not_authorized
    end
  end
end
