class Report < ApplicationRecord
  enum report_status: {
    published: 0,
    unpublished: 1,
    draft: 2
  }
  belongs_to :user
  belongs_to :concert
  has_one :report_body
  has_many :report_favorites
  has_many :favorited_by_users, through: :report_favorites, source: :user
end
