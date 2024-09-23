class UserFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :favorited_user, class_name: "User"
end