class AdsController < ApplicationController
  before_action :authenticate_user!

  def index
    @ads = ads
  end

  def show
    @ad = ads.find(params[:id])
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
    @ad = ads.find(params[:id])

    if @ad.status == :active
      flash[:warning] << 'This ad is active! Be careful!'
    end
  end

  def update
    ad = ads.find(params[:id])

    if ad.update(ad_params)
      redirect_to ad
    else
      flash[:error] = ad.errors.full_messages
    end
  end

  def destroy
    ads.find(params[:id]).destroy
    redirect_to ads_path
  end

  protected

  def ads
    @ads ||= current_user.ads
  end

  def ad_params
    params.require(:ad).permit(:title, :body, :image_url)
  end
end
