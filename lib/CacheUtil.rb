#encoding: utf-8
require 'dalli'

module CacheUtil
  
#
#
#
def find(key)
  client = Dalli::Client.new;
  client.get(key)
end

#
#
#
def save(key, value)
  client = Dalli::Client.new;
  client.put(key, data)
end

end