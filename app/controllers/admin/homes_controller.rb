class Admin::HomesController < Admin::BaseController
  # style_cheatsheet アクションは認証スキップ
  skip_before_action :authenticate_admin!, only: [:style_cheatsheet]

  def top
    @users = User.all
  end

  def style_cheatsheet
    @sections = [
      { id: 'margin', title: 'マージン' },
      { id: 'padding', title: 'パディング' },
      { id: 'title', title: 'タイトル' },
      { id: 'color', title: '文字色' },
      { id: 'backgroundcolor', title: '背景色' },
      { id: 'fontsize', title: 'フォントサイズ' },
      { id: 'border', title: 'ボーダー' },
      { id: 'button', title: 'ボタン' },
      { id: 'link', title: 'リンク' },
      { id: 'section', title: 'セクション' },
      { id: 'inner', title: 'インナー' },
      { id: 'col2', title: '2カラムレイアウト' },
      { id: 'menu', title: 'メニュー' },
      { id: 'scrollposition', title: 'スクロール位置調整' },
      { id: 'code', title: 'コードブロック' },
      { id: 'startset', title: 'ページスタートセット' },
      { id: 'field', title: 'フォームフィールド' },
      { id: 'textalign', title: 'テキスト配置' },
      { id: 'maxh', title: '最大高さオーバーフロー' },
      { id: 'inactive', title: '非活性' },
      { id: 'profile', title: 'プロフィール' },
      { id: 'table', title: 'テーブル' },
      { id: 'diff', title: '差分' },
    ]
  end

  def destroy_user
    user = User.find(params[:id]);
    user.destroy
    redirect_to admin_root_path, notice: "ユーザー：#{user.name}を削除しました"
  end
end
