class Song < ApplicationRecord
    has_many :set_list_orders
    has_many :sections, through: :set_list_orders
end
