class SetListOrder < ApplicationRecord
  belongs_to :section
  belongs_to :song

  accepts_nested_attributes_for :song
  validates_associated :song

  # デフォルトの並び順を設定
  default_scope { order(:position) }
  
  # バリデーション
  validates :position, numericality: { only_integer: true, allow_nil: true }
  
  # コールバック
  before_create :set_default_position
  after_update :reorder_items, if: :saved_change_to_position?

  private

  def set_default_position
    last_position = section.set_list_orders.maximum(:position) || 0
    self.position = last_position + 1
  end

  def reorder_items
    return unless section
    
    SetListOrder.transaction do
      if saved_change_to_position?
        old_position, new_position = saved_change_to_position
        
        if old_position > new_position
          # 上に移動した場合
          section.set_list_orders
                .where('position >= ? AND position < ?', new_position, old_position)
                .where.not(id: id)
                .update_all('position = position + 1')
        else
          # 下に移動した場合
          section.set_list_orders
                .where('position > ? AND position <= ?', old_position, new_position)
                .where.not(id: id)
                .update_all('position = position - 1')
        end
      end
    end
  end
end