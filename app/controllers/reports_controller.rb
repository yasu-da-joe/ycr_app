class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: [:new, :create, :add_song]

  def new
    @report.sections.build if @report.sections.empty?
    @report.sections.first.set_list_orders.build if @report.sections.first.set_list_orders.empty?
  end

  def create
    @report.assign_attributes(report_params)

    if params[:draft]
      @report.report_status = :draft
      save_message = '下書きを保存しました'
    elsif params[:publish]
      @report.report_status = :published
      save_message = 'レポートを保存しました'
    end

    if @report.save
      render json: { success: true, message: save_message, redirect_url: report_path(@report) }
    else
      render json: { success: false, errors: @report.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def add_song
    @report = Report.find(params[:id])
    @section = @report.sections.first_or_create
    @set_list_order = @section.set_list_orders.build
  
    respond_to do |format|
      format.html { render partial: 'songs/add_song_form', locals: { report: @report, section: @section, set_list_order: @set_list_order }, layout: false }
      format.json { render json: { success: true, html: render_to_string(partial: 'songs/add_song_form', locals: { report: @report, section: @section, set_list_order: @set_list_order }, layout: false) } }
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: 'Report not found' }, status: :not_found
  end

  def initialize_report
    begin
      @report = current_user.reports.create!(report_status: :draft)
      render json: { success: true, report_id: @report.id }
    rescue ActiveRecord::RecordInvalid => e
      render json: { success: false, error: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue => e
      Rails.logger.error "Error in initialize_report: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { success: false, error: "An unexpected error occurred: #{e.message}" }, status: :internal_server_error
    end
  end

  private

  def set_report
    @report = current_user.reports.find_or_initialize_by(report_status: :draft)
  end

  def report_params
    params.require(:report).permit(
      :concert_id, 
      :concert_name, 
      :concert_date, 
      :artist_name, 
      :impression,
      sections_attributes: [:id, :name, set_list_orders_attributes: [:id, :order, song_attributes: [:id, :name, :artist]]]
    )
  end

  def song_params
    params.require(:set_list_order).require(:song_attributes).permit(:name, :artist)
  end

  def set_list_order_params
    params.require(:set_list_order).permit(:body, song_attributes: [:name, :artist])
  end
end