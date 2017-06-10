class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.order('created_at DESC').page params[:page]

    respond_to do |format|
      format.js
      format.html
    end
  end

  def link_through
    @notification = Notification.find(params[:id])
    @notification.update read: true
    redirect_to post_path @notification.post
  end
end
