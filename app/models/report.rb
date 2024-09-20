class Report < ApplicationRecord
  has_many :report_favorits
  has_many :favorited_by, through: :report_favorits, source: :user
end
