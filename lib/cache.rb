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
  def delete(key)
    client = Dalli::Client.new;
    client.delete(key)
  end

  #
  #
  #
  def append(key, value)
    client = Dalli::Client.new;
    client.append(key, value)
  end
  
  #
  #
  #
  def set_raw(key, value)
    client = Dalli::Client.new;
    client.set(key, value, 0, :raw => true)
  end
  
  def get_raw(key)
    client = Dalli::Client.new;
    client.get(key, :raw => true)
  end

  #
  #
  #
  def incr(key)
    client = Dalli::Client.new;
    client.incr(key)
  end
end