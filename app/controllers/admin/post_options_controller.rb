class Admin::PostOptionsController < ApplicationController
  def index
    @languages = Language.all
    @new_language = Language.new(color: "none")
  end
end
