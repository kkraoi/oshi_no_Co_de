require "base64"
require "json"
require "net/https"
# ↑ これらはRubyに標準的に組み込まれているライブラリ

module Language
  class << self
    def get_sentiment_data(text)
      # 感情分析用のAPIのURLを作成
      # エンドポイント: https://language.googleapis.com/
      # リソース: v1/documents:analyzeSentiment
      # クエリ: ?key=APIキー
      api_url = "https://language.googleapis.com/v1/documents:analyzeSentiment?key=#{ENV['GOOGLE_API_KEY']}"

      # APIリクエストの本文（JSON）
      # https://cloud.google.com/natural-language/docs/reference/rest/v1/documents/analyzeSentiment?hl=ja
      params = {
        "document": {
          type: "PLAIN_TEXT", # HTMLにしたらHTMLタグを無視することができる！
          content: text
        }
      }.to_json

      # HTTPの雛形を作成
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      # リクエスト作成
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'

      # リクエストを送信し、レスポンスを受ける（ブロッキングメソッド）
      response = https.request(request, params)

      # レスポンスを整形する
      response_body = JSON.parse(response.body)
      if (error = response_body['error']).present?
        raise error['message']
      else
        response_body['documentSentiment']['score']
      end 
    end
  end
end