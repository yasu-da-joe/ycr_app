class User < ApplicationRecord
    # ユーザーが他のユーザーをフォロー
    has_many :user_favorites
    has_many :favorited_users, through: :user_favorites, source: :favorited_user
  
    # ユーザーが他のユーザーにフォローされる
    has_many :inverse_user_favorites, class_name: "UserFavorite", foreign_key: "favorited_user_id"
    has_many :followers, through: :inverse_user_favorites, source: :user
  
    # レポートのイイネ
    has_many :report_favorites
    has_many :favorited_reports, through: :report_favorites, source: :report
  end