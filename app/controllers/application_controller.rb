class ApplicationController < ActionController::Base
  # Devise ヘルパーをすべての view で使えるようにする
  helper_method :currnet_user, :user_signed_in?
end
