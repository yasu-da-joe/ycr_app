class Section < ApplicationRecord
  belongs_to :report
  has_many :set_list_orders, dependent: :destroy
  has_many :songs, through: :set_list_orders

  accepts_nested_attributes_for :set_list_orders, allow_destroy: true
end
