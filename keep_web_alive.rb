require 'bundler'
require 'securerandom'
require 'rest-client'

base_path = File.realpath(File.dirname(__FILE__))
config_file = File.join(base_path, 'config.yml')
user_config = File.exists?(config_file) ? YAML.load_file(config_file) : {}
user_config[:search] = "http://www.google.com" unless user_config[:search]
user_config[:ip] = "ifconfig.me/ip"            unless user_config[:ip]
user_config[:silent] = false                   unless user_config[:silent]
user_config[:cyclic] = false                   unless user_config[:cyclic]
user_config[:sleep] = 10                       unless user_config[:sleep]

RestClient.proxy = user_config[:proxy] if user_config[:proxy]

loop do
   RestClient.get(user_config[:search], q: SecureRandom.urlsafe_base64(20)) if user_config[:search]
   if user_config[:ip]
      ip = RestClient.get(user_config[:ip])
      puts ip unless user_config[:silent]
   end
   break unless user_config[:cyclic]
   sleep(user_config[:sleep])
end

