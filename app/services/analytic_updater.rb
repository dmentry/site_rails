module AnalyticUpdater
  def self.call(params_visitor:)
    @params_visitor = params_visitor

    time_visited     = @params_visitor['visitor_data']['time_visited'].to_datetime
    page_name        = @params_visitor['visitor_data']['page_name']
    referrer         = @params_visitor['visitor_data']['referrer']
    browser_name     = @params_visitor['visitor_data']['browser_name']
    browser_platform = @params_visitor['visitor_data']['browser_platform']
    browser_language = @params_visitor['visitor_data']['browser_language']
    size_screen_w    = @params_visitor['visitor_data']['size_screen_w']
    size_screen_h    = @params_visitor['visitor_data']['size_screen_h']
    country          = @params_visitor['visitor_data']['country']
    region_name      = @params_visitor['visitor_data']['region_name']
    lat              = @params_visitor['visitor_data']['lat']
    lon              = @params_visitor['visitor_data']['lon']
    timezone         = @params_visitor['visitor_data']['timezone']
    u_id             = @params_visitor['visitor_data']['u_id']
    uniq_visitor     = if @params_visitor['uniq_visitor'].present?
                         true
                       else
                         false
                       end

    # Не нужно записывать, если это админ ходит по своим разделам
    if !(page_name =~ /users/ || page_name =~ /photos/)
      visitor = Visitor.create(
        time_visited: time_visited, 
        page_name: page_name,
        referrer: referrer,
        browser_name: browser_name,
        browser_platform: browser_platform,
        browser_language: browser_language,
        size_screen_w: size_screen_w,
        size_screen_h: size_screen_h,
        country: country,
        region_name: region_name,
        lat: lat,
        lon: lon,
        timezone: timezone,
        u_id: u_id,
        uniq_visitor: uniq_visitor
      )

      analytic = Analytic.where('views_period_month=? AND views_period_year=?', Date.today.month, Date.today.year).first.presence || 
        Analytic.create(views_period_month: Date.today.month, views_period_year: Date.today.year)

      if @params_visitor['uniq_visitor'].present?
        Analytic.increment_counter(:uniq_visitor, analytic.id)
      else
        Analytic.increment_counter(:repeat_visitor, analytic.id)
      end
    end
  end
end
