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
    params = {
        app_id: self.config.app_id,
    }.merge(attributes)
    params = params.merge({sign: self.sign(params)})

    puts "\n\n#{api_path}\n"
    puts params

    url = "#{self.config.api_url}/#{api_path}"
    uri = URI(url)
    res = Net::HTTP.post_form(uri, params)

    body = res.body
    puts body
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
  #notify_payment(tran_id:xxx,pay_time: Time.now.to_i,app_current_time: Time.now.to_i,deliver_now:true)
  def notify_payment(attributes)
    post_request('/notifyPayment', attributes)
  end

  #出货结果询问
  #trade_order_status(tran_id:xxx)
  def trade_order_status(attributes)
    post_request('/getTradeOrderStatus', attributes)
  end

  #搜索售货机接口
  def search_vm_list(attributes)
    post_request('/searchVmList', attributes)
  end

  #根据售货机查询商品列表接口
  def product_list(attributes)
    post_request('/productList', attributes)
  end

  #根据售货机和商品买码接口
  def order_code(attributes)
    post_request('/orderCode', attributes)
  end

  #出货接口
  def deliver_trade(attributes)
    post_request('/deliverTrade', attributes)
  end

  #查询售货机货道是否售卖某个商品
  def check_product_in_vm(attributes)
    post_request('/checkProductInVm', attributes)
  end

  #检查售货机是否联网
  def check_vm_status(attributes)
    post_request('/checkVmstatus', attributes)
  end

  #根据商品id和售货机编号获取商品详情
  def product_info(attributes)
    post_request('/productInfo', attributes)
  end
end
