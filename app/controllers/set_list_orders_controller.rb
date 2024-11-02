class SetListOrdersController < ApplicationController
  before_action :require_login
  before_action :set_report_and_section
  before_action :set_set_list_order, only: [:edit, :update, :destroy, :update_position]

  def new
    @set_list_order = @section.set_list_orders.build
    @set_list_order.build_song

    render partial: 'songs/add_song_form'
  end

  def create
    @set_list_order = @section.set_list_orders.build(set_list_order_params)
  
    if request.format.json? || request.xhr?
      if @set_list_order.save
        render json: {
          success: true,
          html: render_to_string(
            partial: 'songs/song', 
            locals: { set_list_order: @set_list_order }, 
            formats: [:html]
          ),
          message: '曲が追加されました'
        }
      else
        render json: {
          success: false,
          errors: @set_list_order.errors.full_messages,
          message: 'エラーが発生しました'
        }, status: :unprocessable_entity
      end
    else
      respond_to do |format|
        if @set_list_order.save
          format.html { 
            if @report.draft?
              redirect_to new_report_path(new: true), notice: '曲が追加されました'
            else
              redirect_to edit_report_path(@report), notice: '曲が追加されました'
            end
          }
        else
          format.html { render :new }
        end
      end
    end
  end

  def edit
    respond_to do |format|
      format.html do
        render partial: 'songs/add_song_form', locals: { 
          set_list_order: @set_list_order,
          report: @report,
          section: @section
        }, layout: false
      end
      format.json do
        render json: {
          set_list_order: @set_list_order,
          song: @set_list_order.song,
          body: @set_list_order.body
        }
      end
    end
  end

  def update
    Rails.logger.debug "Received request format: #{request.format}"
    
    # リファラーからアクセス元を判定
    previous_page = request.referer || ''
    is_from_new = previous_page.include?('/new')
    
    respond_to do |format|
      format.html do
        if @set_list_order.update(set_list_order_params)
          # リファラーに基づいてリダイレクト先を分岐
          redirect_path = if is_from_new
            new_report_path(@report)
          else
            edit_report_path(@report)
          end
          
          redirect_to redirect_path, notice: '曲情報が更新されました'
        else
          redirect_to request.referer || edit_report_path(@report),
                      status: :unprocessable_entity,
                      alert: '更新に失敗しました'
        end
      end
      
      format.json do
        if @set_list_order.update(set_list_order_params)
          render json: {
            success: true,
            message: '曲情報が更新されました',
            html: render_to_string(
              partial: 'songs/song',
              locals: { set_list_order: @set_list_order }
            ).html_safe
          }
        else
          render json: {
            success: false,
            errors: @set_list_order.errors.full_messages
          }, status: :unprocessable_entity
        end
      end
    end
  end


  def destroy
    @set_list_order = SetListOrder.find(params[:id])
    @set_list_order.destroy
  
    respond_to do |format|
      format.html { redirect_to report_path(@set_list_order.section.report), notice: '曲を削除しました' }
      format.turbo_stream { render turbo_stream: turbo_stream.remove("song-#{@set_list_order.id}") }
    end
  end

  def update_position
    if @set_list_order.update(position: params[:position])
      render json: { success: true }
    else
      render json: { success: false, errors: @set_list_order.errors.full_messages }
    end
  end

  private

  def set_report_and_section
    @report = Report.find(params[:report_id])
    @section = @report.sections.find(params[:section_id])
  end

  def set_list_order_params
    params.require(:set_list_order).permit(:body, song_attributes: [:name, :artist, :id])
  end

  def set_order_number
    last_order = SetListOrder.where(section_id: section_id).maximum(:order) || 0
    self.order = last_order + 1
  end

  def set_set_list_order
    @set_list_order = @section.set_list_orders.find(params[:id])
  end
end