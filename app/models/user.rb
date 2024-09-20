class User < ApplicationRecord
    has_many :report_favorits
    has_many :favorited_reports, through: :report_favorits, source: :report
end
