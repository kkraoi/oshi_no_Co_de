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
    ]
  end
end
