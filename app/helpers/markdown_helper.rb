# ヘルパーの仕組み
# - app/helpers フォルダに .rb ファイルとして定義する
# - module を使って定義する（クラスではない）
# - メソッドはビュー内で呼び出せる
# - 自動で読み込まれる（Railsが内部で ApplicationHelper を継承・include してくれる）
# RailsはApplicationController → ApplicationHelper → その他のヘルパーという形で読み込む

require 'kramdown'
 
module MarkdownHelper
  def markdown_to_html(text)
    return "" if text.blank?
    Kramdown::Document.new(
      text,
      input: 'gfm'
    ).to_html.html_safe
  end
end