class UserFavorit < ApplicationRecord
  belongs_to :user
  belongs_to :favorit_user
end
