#encoding: utf-8
require 'dalli'

module Cache

  def get(key)
    Rails.cache.read(key)
  end

  def set(key, value)
    Rails.cache.write(key, value)
  end

  def delete(key)
    Rails.cache.delete(key)
  end

  #
  # 値を登録or更新する
  #
  def append(key, value)
    tmp = Rails.cache.read(key)
    unless (tmp) 
      # 値が無い場合はset
      Rails.cache.write(key, value)
    else
      # すでに値が登録されている場合は、値を更新
      Rails.cache.write(key, "#{tmp}#{value}")
    end
  end
  
  #
  #
  def incr(key)
    Rails.cache.increment(key)
  end
end