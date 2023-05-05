class FeedsController < ApplicationController
  include RestrictedAccess

  def index
    @feeds = Feed.all.order(id: :desc).limit(10)
  end
end