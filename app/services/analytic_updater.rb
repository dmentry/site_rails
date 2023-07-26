module AnalyticUpdater
  def self.call(params_visitor:)
    @params_visitor = params_visitor
puts '***********************************************************************************************'
puts @params_visitor
puts '***********************************************************************************************'

  if @params_visitor['uniq_visitor']
    time_visited     = @params_visitor['uniq_visitor']['time_visited'].to_datetime
    page_name        = @params_visitor['uniq_visitor']['page_name']
    referrer         = @params_visitor['uniq_visitor']['referrer']
    browser_name     = @params_visitor['uniq_visitor']['browser_name']
    browser_language = @params_visitor['uniq_visitor']['browser_language']
    browser_platform = @params_visitor['uniq_visitor']['browser_platform']
    screen_size      = "#{ @params_visitor['uniq_visitor']['size_screen_w'] }x#{ @params_visitor['uniq_visitor']['size_screen_h'] }"
    country          = @params_visitor['uniq_visitor']['country']
    region_name      = @params_visitor['uniq_visitor']['region_name']
    lat              = @params_visitor['uniq_visitor']['lat']
    lon              = @params_visitor['uniq_visitor']['lon']
    timezone         = @params_visitor['uniq_visitor']['timezone']
  elsif @params_visitor['repeat_visitor']
    time_visited     = @params_visitor['repeat_visitor']['time_visited'].to_datetime
  end

  analytic_count = AnalyticCount.where('views_period_month=? AND views_period_year=?', Date.today.month, Date.today.year).first.presence || 
    AnalyticCount.create(views_period_month: Date.today.month, views_period_year: Date.today.year)

  if @params_visitor['uniq_visitor']
    AnalyticCount.increment_counter(:uniq_visitor, analytic_count.id)
  else
    AnalyticCount.increment_counter(:repeat_visitor, analytic_count.id)
  end

    # if @skus
    #   @skus.each do |sko|
    #     sku_count = sko.sku_counts.where('views_period_month=? AND views_period_year=?', Date.today.month, Date.today.year).first.presence || 
    #                   SkuCount.create(views_period_month: Date.today.month, views_period_year: Date.today.year, sku_id: sko.id)



    #     if @refers_to_sku_from_search && !@statistics_count_param
    #       SkuCount.increment_counter(:refers_to_sku_from_search, sku_count.id) if sku_count.refers_to_sku_from_search < sku_count.sku_views_in_search
    #     elsif @refers_to_sku_from_search && @statistics_count_param == :region
    #       SkuCount.increment_counter(:refers_to_sku_from_search_with_region, sku_count.id) if sku_count.refers_to_sku_from_search_with_region < sku_count.sku_views_in_search_with_region

    #       return
    #     elsif @refers_to_sku_from_search && @statistics_count_param == :disease
    #       SkuCount.increment_counter(:refers_to_sku_from_search_with_disease, sku_count.id) if sku_count.refers_to_sku_from_search_with_disease < sku_count.sku_views_in_search_with_disease

    #       return
    #     elsif @refers_to_sku_from_search && @statistics_count_param == :both
    #       SkuCount.increment_counter(:refers_to_sku_from_search_with_disease, sku_count.id) if sku_count.refers_to_sku_from_search_with_disease < sku_count.sku_views_in_search_with_disease

    #       return
    #     end

    #     case @statistics_count_param
    #     when :sku_views_in_search
    #       SkuCount.increment_counter(:sku_views_in_search, sku_count.id)
    #     when :sku_page_views
    #       SkuCount.increment_counter(:sku_page_views, sku_count.id)
    #     when :region
    #       SkuCount.increment_counter(:sku_views_in_search_with_region, sku_count.id)
    #     end
    #   end

    # if uniq_skos_parsed
    #   uniq_skos_parsed.each do |uniqueness_type, sko_ids|
    #     @skus = Sku.includes(:sku_counts).where(id: sko_ids)

    #     @skus.each do |sko|
    #       sku_count = sko.sku_counts.where('views_period_month=? AND views_period_year=?', Date.today.month, Date.today.year).first.presence || 
    #                     SkuCount.create(views_period_month: Date.today.month, views_period_year: Date.today.year, sku_id: sko.id)

    #       case uniqueness_type.to_s
    #       when "_op_uniq_search"
    #         SkuCount.increment_counter(:uniq_visitors_for_sku_in_search, sku_count.id)
    #       when "_op_uniq_search_subj"
    #         SkuCount.increment_counter(:uniq_visitors_for_sku_in_search_with_region, sku_count.id)
    #       when "_op_uniq_search_dis"
    #         SkuCount.increment_counter(:uniq_visitors_for_sku_in_search_with_disease, sku_count.id)
    #       when "_op_uniq_sko"
    #         SkuCount.increment_counter(:uniq_visitors_of_sku_page, sku_count.id)
    #       end
    #     end
    #   end
    # end
  end
end
