class ApplicationController < ActionController::Base
  # Railsのcontrollerメソッドは、そのままではviewでは使えないが、開発環境では自動でviewを使えるようにしてくれる。
  # 開発環境ではクラスの再読み込みが効いているため、Deviseの定義が毎回読み込まれ、viewに反映される。
  # 本番では全てのクラスが一括で読み込まれるが、この時の読み込み順によってDiveseヘルパーがviewに渡されず、user_signed_in?などが参照エラーとなる。
  # helper_method を書くことで「この controller メソッドを view でも使えるように」と指示できる。
  # ↓ Devise ヘルパーをすべての view で使えるようにする。
  helper_method :current_user, :user_signed_in?
end
