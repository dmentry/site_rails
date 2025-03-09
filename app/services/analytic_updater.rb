module AnalyticUpdater
  def self.call(params_visitor:)
    @params_visitor = params_visitor

    ip               = @params_visitor.dig('visitor_data', 'ip')
    time_visited     = @params_visitor.dig('visitor_data', 'time_visited')&.to_datetime
    timezone         = @params_visitor.dig('visitor_data', 'timezone')
    page_name        = @params_visitor.dig('visitor_data', 'page_name')
    referrer         = @params_visitor.dig('visitor_data', 'referrer')
    common_info      = @params_visitor.dig('visitor_data', 'common_info')
    platform         = @params_visitor.dig('visitor_data', 'platform')
    os               = @params_visitor.dig('visitor_data', 'os')
    browser_language = @params_visitor.dig('visitor_data', 'browser_language')
    size_screen_w    = @params_visitor.dig('visitor_data', 'size_screen_w')
    size_screen_h    = @params_visitor.dig('visitor_data', 'size_screen_h')
    country          = @params_visitor.dig('visitor_data', 'country')
    region           = @params_visitor.dig('visitor_data', 'region')
    city             = @params_visitor.dig('visitor_data', 'city')
    city_lat         = @params_visitor.dig('visitor_data', 'city_lat')
    city_long        = @params_visitor.dig('visitor_data', 'city_long')
    u_id             = @params_visitor.dig('visitor_data', 'u_id')
    uniq_visitor     = if @params_visitor.dig('uniq_visitor').present?
                         true
                       else
                         false
                       end

    visitor = Visitor.create(
      ip: ip,
      time_visited: time_visited, 
      timezone: timezone, 
      page_name: page_name,
      referrer: referrer,
      common_info: common_info,
      platform: platform,
      os: os,
      browser_language: browser_language,
      size_screen_w: size_screen_w,
      size_screen_h: size_screen_h,
      country: country,
      region: region,
      city: city,
      city_lat: city_lat,
      city_long: city_long,
      u_id: u_id,
      uniq_visitor: uniq_visitor
    )

    analytic = Analytic.where('views_period_month=? AND views_period_year=?', Date.today.month, Date.today.year).first.presence || 
      Analytic.create(views_period_month: Date.today.month, views_period_year: Date.today.year)

    if @params_visitor.dig('uniq_visitor').present?
      Analytic.increment_counter(:uniq_visitor, analytic.id)
    else
      Analytic.increment_counter(:repeat_visitor, analytic.id)
    end
  end
end
