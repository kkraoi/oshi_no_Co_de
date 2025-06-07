class Admin::HomesController < Admin::BaseController
  def top
    
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
    ]
  end
end
