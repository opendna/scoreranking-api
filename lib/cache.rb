#encoding: utf-8
require 'dalli'

module Cache

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
    client.set(key, value)
  end

  #
  #
  #
  def append(key, value)
    client = Dalli::Client.new;
    client.append(key, value)
  end
  
  def increment(key)
    client = Dalli::Client.new;
    client.increment(key)
  end
end