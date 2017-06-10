class RemoveViewsFromPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :views, :integer
  end
end
