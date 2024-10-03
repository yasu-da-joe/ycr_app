class SetListOrdersController < ApplicationController
  def create
    @report = Report.find(params[:report_id])
    @section = @report.sections.find(params[:section_id])
    @set_list_order = @section.set_list_orders.build(set_list_order_params)

    if @set_list_order.save
      render json: { success: true, html: render_to_string(partial: 'songs/song', locals: { set_list_order: @set_list_order }, layout: false) }
    else
      render json: { success: false, errors: @set_list_order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_list_order_params
    params.require(:set_list_order).permit(:body, song_attributes: [:name, :artist])
  end
end