class Admin::PostOptionsController < ApplicationController
  def index
    @languages = Language.all
  end
end
