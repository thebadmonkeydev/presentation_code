class AdStatisticsController < ApplicationController
  before_action :authenticate_user!

  def audience
    @audience = current_user.ads.map {|ad| AdStatistics.new(ad).audience }.flatten.compact
  end

  def dashboard
    @ad_stats = current_user.ads.map do |ad|
      {
        ad: ad,
        clicks: AdStatistics.new(ad).clicks,
      }
    end
  end
end
