class FriendshipsController < ApplicationController
    before_filter :authenticate_user!

    def index
        @friends = current_user.friends
        @pending_invited_by = current_user.pending_invited_by
        @pending_invited = current_user.pending_invited
    end

    def request_friend
        @friend = User.find(params[:id])
        #if !@friend
        #    redirect_to :back
        #end
        current_user.invite @friend
        redirect_to :back
    end

    def approve_friend
        @friend = User.find(params[:id])
        current_user.approve @friend
        redirect_to :back
    end

    def remove_friend
        @friend = User.find(params[:id])
        current_user.remove_friendship @friend
        redirect_to :back
    end

    def block_friend
        @blocking = User.find(params[:id])
        current_user.block @blocking
        redirect_to :back
    end

    def unblock_friend
    	@blocked = User.find(params[:id])
    	current_user.unblock @blocked
    	redirect_to :back
    end

    def common_friends
    	@friend = User.find(params[:id])
    	current_user.common_friends_with @friend
    	redirect_to :back
    end
end