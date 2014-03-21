#encoding: utf-8
require 'dalli'

module Cache

  def get(key)
    client = Dalli::Client.new;
    client.get(key)
  end

  def set(key, value)
    client = Dalli::Client.new;
    client.set(key, value)
  end

  def delete(key)
    client = Dalli::Client.new;
    client.delete(key)
  end

  #
  # 値を登録or更新する
  #
  def append(key, value)
    client = Dalli::Client.new;

    tmp = get(key)
    unless (tmp) 
      # 値が無い場合はset
      set(key, value)
    else
      # すでに値が登録されている場合は、値を更新
      tmp += value
      set(key, value)
    end
  end
  
  #
  #
  def incr(key)
    client = Dalli::Client.new;
    client.incr(key)
  end

  #
  #
  def set_raw(key, value)
    client = Dalli::Client.new;
    client.set(key, value, 0, :raw => true)
  end
  
  #
  #
  def get_raw(key)
    client = Dalli::Client.new;
    client.get(key, :raw => true)
  end

end