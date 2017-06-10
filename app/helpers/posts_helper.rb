module PostsHelper
  def display_likes(post)
    votes = post.votes_for.up.by_type(User)
    return list_likers(votes) if votes.size <= 5
    count_likers(votes)
  end

  def liked_post(post)
    if current_user.voted_for? post
      return link_to '', unlike_post_path(post.id), remote: true, id: "like_#{post.id}",
          class: "glyphicon glyphicon-heart btn-lg"
    else
      link_to '', like_post_path(post.id), remote: true, id: "like_#{post.id}",
          class: "like glyphicon glyphicon-heart-empty btn-lg"
    end
  end

  private

  def list_likers(votes)
    user_names = []
    unless votes.blank?
      votes.voters.each do |voter|
        @u = voter.nick_name
        if voter.avatar.exists?
        user_names.push(link_to image_tag(voter.avatar.url(:thumb),title:@u,:class=> "img-circular-like"),
                                profile_path(voter.user_name),
                                class: 'user-img-likes img-circle')
        else
          user_names.push(link_to image_tag('defaultavatar.png',title:@u,:class=> "img-circular-like"),
                                  profile_path(voter.user_name),
                                  class: 'user-img-likes img-circle')
        end
      end
      user_names.to_sentence.html_safe + like_plural(votes)
    end
  end

  def count_likers(votes)
    vote_count = votes.size
    vote_count.to_s + ' likes'
  end

  def like_plural(votes)
    return ' like this' if votes.count > 1
    ' likes this'
  end

  def render_with_hashtags(caption)
    caption.gsub(/#\w+/){|word| link_to word, "/posts/hashtag/#{word.downcase.delete('#')}",{:class=>"nolink",:style=>'color:#1a84a5'}}.html_safe 
  end
end
