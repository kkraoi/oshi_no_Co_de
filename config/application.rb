require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OshiNoCoDe
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # lib以下のファイルのモジュールやクラスをequireをすることなく呼ぶための設定。
    # eager_load: => Rubyファイルが起動時に全て読み込まれる。
    # （おまけ）autoload: => ファイルに初めてアクセスされたときに読み込む
    config.paths.add "lib", eager_load: true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
