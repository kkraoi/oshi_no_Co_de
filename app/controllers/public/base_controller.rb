class Public::BaseController < ApplicationController
  ## ログインしていない場合はアクセス禁止
  before_action :authenticate_user!
end
