class Post < ApplicationRecord

  acts_as_votable
  self.per_page = 10
  validates :user_id, presence: true
  belongs_to :user
  validates :image, presence: true
  has_many :notifications, dependent: :destroy  
  has_many :comments, dependent: :destroy
  validates :caption, length: { minimum: 3, maximum: 200 }
  is_impressionable

  has_and_belongs_to_many :tags

  has_attached_file :image, styles: { :medium => "640x" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  has_attached_file :mp3
  validates_attachment :mp3, :content_type => { :content_type => ["audio/mpeg","audio/mp3"] }, :file_name => { :matches => [/mp3\Z/]}

  after_create do
    post = Post.find_by(id: self.id)
    hashtags = self.caption.scan(/#\w+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      post.tags << tag
    end
  end 

  before_update do
    post = Post.find_by(id: self.id)
    post.tags.clear 
    hashtags = self.caption.scan(/#\w+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      post.tags << tag
    end
  end

end
