require 'bundler'
require 'securerandom'
require 'rest-client'

base_path = File.realpath(File.dirname(__FILE__))
config_file = File.join(base_path, 'config.yml')
user_config = File.exists?(config_file) ? YAML.load_file(config_file) : {}
user_config[:search] = "http://www.google.com" unless user_config[:search]
user_config[:ip] = "ifconfig.me/ip"            unless user_config[:ip]

RestClient.proxy = user_config[:proxy] if user_config[:proxy]

RestClient.get(user_config[:search], q: SecureRandom.urlsafe_base64(20)) if user_config[:search]
puts RestClient.get(user_config[:ip])                                    if user_config[:ip]
