class AdPartialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ad

  def preview
    render partial: "#{ad.type}_preview", locals: { ad: ad }
  end

  def stats
    render partial: "#{ad.type}_stats", locals: { stats: AdStatistics.new(ad) }
  end

  protected

  def set_ad
    @ad = current_user.ads.find(params[:id])
  end
end
