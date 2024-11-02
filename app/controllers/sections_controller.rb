class SectionsController < ApplicationController
  before_action :authenticate_user!
  
  def new
  end

  def update_song_order
    @section = Section.find(params[:id])
    
    begin
      ActiveRecord::Base.transaction do
        params[:song_order].each do |order_params|
          set_list_order = @section.set_list_orders.find(order_params[:id])
          set_list_order.update!(position: order_params[:position])
        end
      end
      
      render json: { success: true, message: '並び順を更新しました' }
    rescue => e
      Rails.logger.error "Error updating set list order: #{e.message}"
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def section_params
    params.require(:section).permit(:name, :position)  
  end

  def reorder_section_songs(section)
    # セクション内の曲を現在の順序で取得し、インデックスを1から振り直す
    section.set_list_orders.order(:order).each_with_index do |set_list_order, index|
      set_list_order.update!(position: index + 1)  
    end
  end
end
