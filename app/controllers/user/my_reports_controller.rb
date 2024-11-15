class User::MyReportsController < ApplicationController
    before_action :require_login
    
    def index
      @reports = case params[:status]
                when 'draft'
                    current_user.reports.drafts.joins(:concert).order('concerts.date DESC')
                when 'published'
                    current_user.reports.published.joins(:concert).order('concerts.date DESC')
                else
                    current_user.reports.published.joins(:concert).order('concerts.date DESC')
                end
    end
end