class AdJobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ad

  def pause
    @ad.update!(status: :paused)
    AdStatusWorker.perform_later(@ad, :pause)
  end

  def activate
    @ad.update!(status: :active)
    AdStatusWorker.perform_later(@ad, :active)
  end

  def archive
    @ad.update!(status: :archived)
    AdStatusWorker.perform_later(@ad, :archived)
  end

  protected

  def set_ad
    @ad = current_user.ads.find(params[:id])
  end
end
