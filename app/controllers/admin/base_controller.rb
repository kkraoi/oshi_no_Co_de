class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  # app/views/layouts/admin.html.erbのレイアウトファイルを適用する
  layout "admin"
end
