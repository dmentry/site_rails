module AnalyticsHelper
  def timezone_name(shifting)
    offset = shifting.to_i * 60 * 60
    offset_range = (offset-3600)..(offset+3600)
    timezones = ActiveSupport::TimeZone.all.select{|tz| offset_range.include?(tz.utc_offset)}
    timezones.map(&:name)
  end
end
