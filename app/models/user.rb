class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  authenticates_with_sorcery!
  has_many :reports
  
  # ユーザーが他のユーザーをフォロー
  has_many :user_favorites
  has_many :favorited_users, through: :user_favorites, source: :favorited_user

  # ユーザーが他のユーザーにフォローされる
  has_many :inverse_user_favorites, class_name: "UserFavorite", foreign_key: "favorited_user_id"
  has_many :followers, through: :inverse_user_favorites, source: :user

  # レポートのイイネ
  has_many :report_favorites
  has_many :favorited_reports, through: :report_favorites, source: :report

  validates :email, uniqueness: true, presence: true
  validates :email, :email_format => {:message => '正しいメールアドレスを入力してください'}
  validates :password, presence: true 
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  end