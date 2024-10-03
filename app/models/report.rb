class Report < ApplicationRecord
  belongs_to :user
  belongs_to :concert, optional: true
  has_one :report_body, dependent: :destroy
  has_many :sections, dependent: :destroy
  has_many :set_list_orders, through: :sections
  has_many :songs, through: :set_list_orders
  has_many :report_favorites, dependent: :destroy
  has_many :favorited_by_users, through: :report_favorites, source: :user

  enum report_status: { published: 0, unpublished: 1, draft: 2 }

  accepts_nested_attributes_for :report_body, allow_destroy: true
  accepts_nested_attributes_for :sections, allow_destroy: true
  accepts_nested_attributes_for :songs, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :set_list_orders, allow_destroy: true

  # バリデーション
  validates :report_status, presence: true
  validates :user, presence: true
  validates :concert, presence: true, if: :published?
  validates :report_body, presence: true, if: :published?

  # スコープ
  scope :drafts, -> { where(report_status: :draft) }
  scope :published, -> { where(report_status: :published) }

  # 曲を追加するメソッド
  def add_song(song_params)
    set_list_order = sections.first_or_create.set_list_orders.build
    set_list_order.build_song(song_params)
    set_list_order
  end

  # 公開状態を確認するメソッド
  def published?
    report_status == 'published'
  end

  # 下書き状態を確認するメソッド
  def draft?
    report_status == 'draft'
  end

  # レポートを初期化するメソッド
  def self.initialize_for_user(user)
    user.reports.create(report_status: :draft)
  end
end