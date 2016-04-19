class AdsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ad, except: [:index, :new, :create, :audience, :dashboard]

  def index
    @ads = ads
  end

  def show
  end

  def new
    @ad = Ad.new
  end

  def create
    ad = Ad.new(ad_params)
    ad.user = current_user

    if ad.save
      flash[:notice] << 'Ad Created Successfully!'
      redirect_to ad
    else
      flash[:error] = ad.errors.full_messages
    end
  end

  def edit
    if @ad.status == :active
      flash[:warning] << 'This ad is active! Be careful!'
    end
  end

  def update
    if @ad.update(ad_params)
      redirect_to @ad
    else
      flash[:error] = @ad.errors.full_messages
    end
  end

  def destroy
    @ad.destroy
    redirect_to ads_path
  end

  def preview
    render partial: "#{@ad.type}_preview", locals: { ad: @ad }
  end

  def stats
    render partial: "#{@ad.type}_stats", locals: { stats: AdStatistics.new(@ad) }
  end

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

  protected

  def ads
    @ads ||= current_user.ads
  end

  def ad_params
    params.require(:ad).permit(:title, :body, :image_url)
  end

  def set_ad
    @ad = ads.find(params[:id])
  end
end
