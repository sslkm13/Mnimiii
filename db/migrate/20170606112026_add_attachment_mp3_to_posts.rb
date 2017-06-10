class AddAttachmentMp3ToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.attachment :mp3
    end
  end

  def self.down
    remove_attachment :posts, :mp3
  end
end
