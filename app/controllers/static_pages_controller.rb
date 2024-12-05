class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  
  def about_us
  end

  def terms_of_service
  end

  def privacy_policy
  end
end
