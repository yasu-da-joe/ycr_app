class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: [:create, :update, :add_song]
  before_action :set_report_for_edit, only: [:edit]

  def new
  latest_report = current_user.reports
                             .includes(:concert, :report_body, 
                                     sections: { set_list_orders: :song })
                             .drafts
                             .order(created_at: :desc)
                             .first

  if params[:new]
    @report = latest_report
  else
    @report = latest_report || current_user.reports.build(report_status: :draft)
  end

  if @report&.persisted?
    @report.concert_name = @report.concert&.name
    @report.concert_date = @report.concert&.date
    @report.artist_name = @report.concert&.artist
    @report.impression = @report.report_body&.body
    @section = @report.sections.first_or_create!(name: "セットリスト", order: 1)
    @existing_set_list_orders = @report.sections.flat_map(&:set_list_orders)
                                      .sort_by { |o| [o.position || Float::INFINITY, o.created_at] }
  else
    @report.sections.build(name: "セットリスト", order: 1) if @report.sections.empty?
    @section = @report.sections.first
    @existing_set_list_orders = []
  end
end

  def create
    @report = current_user.reports.new

    if params[:publish]
      @report.report_status = :published
      save_message = 'レポートを保存しました'
    else
      @report.report_status = :draft
      save_message = '下書きを保存しました'
    end

    # コンサート情報の取得または作成
    concert = Concert.find_or_create_by(
      name: report_params[:concert_name],
      artist: report_params[:artist_name],
      date: report_params[:concert_date]
    )

    # レポートの関連付け
    @report.concert = concert

    # 感想の保存
    @report.build_report_body(body: report_params[:impression])

    respond_to do |format|
      if @report.save
        format.json { render json: { 
          success: true, 
          message: save_message, 
          redirect_url: report_path(@report) 
        }}
      else
        format.json { render json: { 
          success: false, 
          errors: @report.errors.full_messages 
        }, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:publish]
      @report.report_status = :published
      save_message = 'レポートを保存しました'
    else
      @report.report_status = :draft
      save_message = '下書きを保存しました'
    end

    # コンサート情報の取得または作成
    concert = Concert.find_or_create_by(
      name: report_params[:concert_name],
      artist: report_params[:artist_name],
      date: report_params[:concert_date]
    )

    # レポートの関連付け
    @report.concert = concert

    # 感想の保存
    @report.build_report_body unless @report.report_body
    @report.report_body.body = report_params[:impression]

    respond_to do |format|
      if @report.save
        format.json { render json: { 
          success: true, 
          message: save_message, 
          redirect_url: report_path(@report) 
        }}
      else
        format.json { render json: { 
          success: false, 
          errors: @report.errors.full_messages 
        }, status: :unprocessable_entity }
      end
    end
  end

  def show
    @report = current_user.reports.includes(:concert, :report_body, sections: { set_list_orders: :song }).find(params[:id])
    @existing_set_list_orders = @report.sections.first.set_list_orders if @report.sections.any?
  rescue ActiveRecord::RecordNotFound
    redirect_to reports_path, alert: 'レポートが見つかりません'
  end

  def edit
    # @reportの存在確認は既にset_report_for_editで行われている
    @existing_set_list_orders = if @report.sections.any?
      @report.sections.first.set_list_orders.includes(:song)
        .order('set_list_orders.position NULLS LAST, created_at')
    else
      []
    end
  
    # フォーム用の値を設定
    @report.concert_name = @report.concert&.name
    @report.concert_date = @report.concert&.date
    @report.artist_name = @report.concert&.artist
    @report.impression = @report.report_body&.body
  
    @section = @report.sections.first_or_create!(name: "セットリスト", order: 1)
    @existing_set_list_orders = @section.set_list_orders.order(:position)
  end

  def add_song
    @report = if params[:id] == 'undefined' || params[:id].nil?
      # 直近の下書きレポートを使用するか、なければ新規作成
      current_user.reports.drafts.order(created_at: :desc).first_or_create!(report_status: :draft)
    else
      # 編集時は指定されたレポートを使用
      current_user.reports.find(params[:id])
    end
  
    @section = @report.sections.first_or_create
    @set_list_order = @section.set_list_orders.build
  
    respond_to do |format|
      format.html { render partial: 'songs/add_song_form', locals: { report: @report, section: @section, set_list_order: @set_list_order }, layout: false }
      format.json { render json: { 
        success: true, 
        report_id: @report.id,
        html: render_to_string(
          partial: 'songs/add_song_form', 
          locals: { report: @report, section: @section, set_list_order: @set_list_order }, 
          layout: false
        ) 
      }}
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: 'Report not found' }, status: :not_found
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
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

  def create_new
    @report = current_user.reports.create!(report_status: :draft)
    @report.sections.create! # セクションも作成
  
    # 新規作成専用のパスにリダイレクト
    respond_to do |format|
      format.html { redirect_to new_report_path(new: true) }
      format.json { 
        render json: {
          success: true, 
          redirect_url: new_report_path(new: true)
        }
      }
    end
  end

  def update_order
    @section = Section.find(params[:section_id])
    
    params[:song_order].each do |order|
      set_list_order = @section.set_list_orders.find(order[:id])
      set_list_order.update(position: order[:position])
    end
  
    render json: { success: true }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def report_params
    params.require(:report).permit(
      :concert_name,    # コンサート名
      :concert_date,    # 開催日時
      :artist_name,     # アーティスト名
      :impression       # 感想
    )
  end

  def set_report
    return unless params[:id].present? && params[:id] != 'undefined'
    
    @report = current_user.reports.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Failed to find report: #{e.message}"
    respond_to do |format|
      format.html { redirect_to reports_path, alert: 'レポートが見つかりません' }
      format.json { 
        render json: { 
          success: false, 
          message: 'レポートが見つかりません', 
          debug: {
            user_id: current_user.id,
            report_id: params[:id],
            action: action_name
          }
        }, status: :not_found 
      }
    end
  end

  def set_report_for_edit
    @report = Report.includes(:concert, :report_body, sections: { set_list_orders: :song })
                    .where(id: params[:id], user_id: current_user.id)
                    .first

    unless @report
      redirect_to reports_path, alert: 'レポートが見つかりません'
    end
  end

  def song_params
    params.require(:set_list_order).require(:song_attributes).permit(:name, :artist)
  end

  def set_list_order_params
    params.require(:set_list_order).permit(:body, song_attributes: [:name, :artist])
  end
end