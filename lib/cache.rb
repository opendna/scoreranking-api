#encoding: utf-8
require 'dalli'

module Cache

  #
  #
  #
  def find_from_cache(key)
    client = Dalli::Client.new;
    client.get(key)
  end

  #
  #
  #
  def save_to_cache(key, value)
    client = Dalli::Client.new;
    client.set(key, value)
  end

  #
  #
  #
  def append_to_cache(key, value)
    client = Dalli::Client.new;
    client.append(key, value)
  end
end