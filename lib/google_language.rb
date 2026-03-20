require "base64"
require "json"
require "net/https"
# ↑ これらはRubyに標準的に組み込まれているライブラリ

module GoogleLanguage
  END_POINT = "https://language.googleapis.com"
  class << self
    def get_sentiment_data(text)
      # NOTE:
      # Google Cloud Natural Language API（感情/言語認識）は、GCP側の利用削除後にエラーになり得るため
      # 一時的に無効化しています。
      #
      # 再有効化する場合は、下記のコメントアウトを戻してください。
      nil
    end

    def get_entity_data(html)
      # NOTE:
      # Google Cloud Natural Language API（言語認識/エンティティ抽出）は、GCP側の利用削除後にエラーになり得るため
      # 一時的に無効化しています。
      #
      # 再有効化する場合は、下記のコメントアウトを戻してください。
      { "entities" => [] }
    end

    private

    # 指定された Google Cloud Natural Language API のエンドポイントに、JSON形式のPOSTリクエストを送信し、レスポンスをパースして返す。
    #
    # @param api_url [String] APIのエンドポイントURL（APIキー付き）
    # @param params [String] JSON形式のリクエスト本文
    # @return [Hash] パース済みのレスポンスボディ（Hash形式）
    # @raise [RuntimeError] APIがエラーを返した場合、そのメッセージを例外として発生させる
    def send_request(api_url, params)
      # NOTE:
      # Google Cloud Natural Language API へのHTTPリクエストを一時的に無効化しています。
      # （`get_sentiment_data` / `get_entity_data` 側でも無効化済みですが、万一呼ばれても外部通信しないため）
      {}
    end
  end
end