class Concert < ApplicationRecord
    has_many :reports

    validates :name, presence: true
    validates :date, presence: true
    validates :artist, presence: true
end
