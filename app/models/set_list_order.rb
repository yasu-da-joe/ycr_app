class SetListOrder < ApplicationRecord
  belongs_to :section
  belongs_to :song

  accepts_nested_attributes_for :song
end
