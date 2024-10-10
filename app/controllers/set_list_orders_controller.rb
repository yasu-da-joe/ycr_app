class SetListOrdersController < ApplicationController
  before_action :require_login
  before_action :set_report_and_section

  def new
    @set_list_order = @section.set_list_orders.build
    @set_list_order.build_song
  end

  def create
    @set_list_order = @section.set_list_orders.build(set_list_order_params)
  
    respond_to do |format|
      if @set_list_order.save
        format.json {
          render json: {
            success: true,
            html: render_to_string(partial: 'songs/song', locals: { set_list_order: @set_list_order }, formats: [:html]),
            message: '曲が追加されました'
          }
        }
      else
        format.json {
          render json: {
            success: false,
            errors: @set_list_order.errors.full_messages,
            message: 'エラーが発生しました'
          }, status: :unprocessable_entity
        }
      end
    end
  end

  private

  def set_report_and_section
    @report = Report.find(params[:report_id])
    @section = @report.sections.find(params[:section_id])
  end

  def set_list_order_params
    params.require(:set_list_order).permit(:body, song_attributes: [:name, :artist])
  end
end