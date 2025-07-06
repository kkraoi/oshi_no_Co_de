require "base64"
require "json"
require "net/https"
# ↑ これらはRubyに標準的に組み込まれているライブラリ

module GoogleLanguage
  END_POINT = "https://language.googleapis.com"
  class << self
    def get_sentiment_data(text)
      # 感情分析用のAPIのURLを作成
      # エンドポイント: https://language.googleapis.com/
      # リソース: v1/documents:analyzeSentiment
      # クエリ: ?key=APIキー
      api_url = "#{END_POINT}/v1/documents:analyzeSentiment?key=#{ENV['GOOGLE_API_KEY']}"

      # APIリクエストの本文（JSON）
      # https://cloud.google.com/natural-language/docs/reference/rest/v1/documents/analyzeSentiment?hl=ja
      params = {
        "document": {
          type: "PLAIN_TEXT", # HTMLにしたらHTMLタグを無視することができる！
          content: text
        }
      }.to_json

      # dig() => response_body['documentSentiment']['score']と同じ感じ
      send_request(api_url, params)&.dig("documentSentiment", "score")
    end

    def get_entity_data(html)
      api_url = "#{END_POINT}/v1/documents:analyzeEntities?key=#{ENV['GOOGLE_API_KEY']}"

      params = {
        "document": {
          type: "HTML",
          content: html
        }
      }.to_json

      send_request(api_url, params)
    end

    private

    # 指定された Google Cloud Natural Language API のエンドポイントに、JSON形式のPOSTリクエストを送信し、レスポンスをパースして返す。
    #
    # @param api_url [String] APIのエンドポイントURL（APIキー付き）
    # @param params [String] JSON形式のリクエスト本文
    # @return [Hash] パース済みのレスポンスボディ（Hash形式）
    # @raise [RuntimeError] APIがエラーを返した場合、そのメッセージを例外として発生させる
    def send_request(api_url, params)
      # HTTPの雛形を作成
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      # リクエスト作成
      request = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "application/json"

      # リクエストを送信し、レスポンスを受ける（ブロッキングメソッド）
      response = https.request(request, params)

      # レスポンスを整形する
      response_body = JSON.parse(response.body)
      if (error = response_body["error"]).present?
        raise error["message"]
      else
        response_body
      end
    end
  end
end