# Load config/config.yml, store to CONFIG
CONFIG = YAML.load(File.read(File.expand_path('../../config.yml', __FILE__)))[Rails.env]

WEIBO = YAML.load(File.read(File.expand_path('../../weibo.yml', __FILE__)))[Rails.env]
