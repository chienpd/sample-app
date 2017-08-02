class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :index

  attr_reader :user

  def index
    return unless user
    @users = user.send(params[:type]).paginate page: params[:page]
  end

  def create
    @user = User.find_by id: params[:followed_id]
    current_user.follow user
    @relationship_destroy = relationship_destroy
    handle_ajax user
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow user
    @relationship_build = relationship_build
    handle_ajax user
  end

  private

  def find_user
    @user = User.find_by id: params[:user_id]
  end

  def relationship_build
    current_user.active_relationships.build
  end

  def relationship_destroy
    current_user.active_relationships.find_by followed_id: user.id
  end

  def handle_ajax user
    respond_to do |format|
      format.html{redirect_to user}
      format.js
    end
  end
end
