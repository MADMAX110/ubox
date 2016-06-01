require "ubox/version"
require 'ubox/configuration'
require 'digest'
require 'uri'
require 'net/http'
require 'json'

module Ubox
  extend self
  #config
  attr_writer :config

  def config
    @config ||= Configuration.new
  end

  def configure
    yield(config)
  end

  #获取签名
  def sign(params)
    str = params.keys.reject { |k| k.to_sym==:sign }.sort_by { |k| k }.inject('') do |s, key|
      s += "#{key}=#{params[key]}"
      s
    end
    Digest::SHA1.hexdigest("#{str}_#{self.config.app_key}")
  end

  def to_params(params)
    params.inject([]) { |a, (k, v)| a<<"#{k}=#{v}"; a }.join("&")
  end

  #商品详情
  def product_detail(qr_string)
    params = {
        app_id: self.config.app_id,
        qr_string: qr_string
    }
    params = params.merge({sign: self.sign(params)})

    url = "#{self.config.api_url}/getProductDetail"
    uri = URI(url)
    res = Net::HTTP.post_form(uri, params)

    body = res.body
    JSON.parse(body)
  end

end
