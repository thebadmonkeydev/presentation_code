class PagesController < ApplicationController
  def index
    @testimonials = Recommendations.all
    @images = Images.where(published: true)
  end

  def team
    @team = User.where(role: :employee)
  end

  def contact
  end

  def about
  end
end
