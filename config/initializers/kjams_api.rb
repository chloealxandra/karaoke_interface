rails_root = ENV['RAILS_ROOT'] || File.dirname(__FILE__) + '/../..'
rails_env = ENV['RAILS_ENV'] || 'development'

kjams_config = YAML.load_file(rails_root + '/config/kjams_api.yml')
$kjams_api = kjams_config[rails_env]