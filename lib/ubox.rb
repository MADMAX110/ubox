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


  def post_request(api_path, attributes)
    puts attributes
    params = {
        app_id: self.config.app_id,
        tran_id: attributes[:tran_id]
    }.merge(attributes)
    params = params.merge({sign: self.sign(params)})

    url = "#{self.config.api_url}/#{api_path}"
    uri = URI(url)
    res = Net::HTTP.post_form(uri, params)

    body = res.body
    JSON.parse(body)
  end

  #商品详情
  def product_detail(attributes)
    post_request('/getProductDetail', attributes)
  end

  #扫码下单请求
  #notify_order(tran_id:xxxx,retain_period:300,app_tran_id:xxxx,app_uid:uid)
  def notify_order(attributes)
    post_request('/notifyOrder', attributes)
  end

  #m买取货吗(支付结果通知)
  #notify_payment(tran_id:xxx,pay_time:13311111,app_current_time:true,deliver_now:true)
  def notify_payment(attributes)
    post_request('/notifyPayment', attributes)
  end

end
