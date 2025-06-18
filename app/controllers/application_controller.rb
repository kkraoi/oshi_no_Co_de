class ApplicationController < ActionController::Base
  # Devise ヘルパーをすべての view で使えるようにする
  helper_method :current_user, :user_signed_in?
end
