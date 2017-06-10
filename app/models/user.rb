class User < ApplicationRecord
  acts_as_voter
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Amistad::FriendModel
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :mp3s, through: :posts,dependent: :destroy
  has_attached_file :avatar, styles: { :thumb => '52x52#' , :medium => '154x154#' }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  validates :user_name, presence: true, length: { minimum: 4, maximum: 16 }
  validates :nick_name, length: { minimum: 3, maximum: 16 }
  validates :full_name, presence: true, length: { minimum: 4, maximum: 16 }
  validates_uniqueness_of :user_name, :email
  has_many :notifications, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
end
