# Ubox

友宝开放api

## Status
代码 已经打包发布到 RubyGems.

[![image](https://ruby-china-files.b0.upaiyun.com/photo/5982eaaa64f467d9dbda03ad4f40ea27.png)](https://rubygems.org/gems/ubox)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ubox'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ubox

## Config
```ruby
  Ubox.configure do |ubox|
    ubox.app_id = 'your_app_id'
    ubox.app_key = 'your_app_key' 
    ubox.api_url = 'http://uboxapi.dev.uboxol.com/opentrade' #正式环境请用正式环境url
  end
```

## Usage

###getProductDetail 获取商品信息(扫码)
```ruby
detail=Ubox.product_detail(qr_string:'http://v.dev.uboxol.com/qr/c0081801_10000870_1')
```

```json
{
 "head": {
      "return_code": 200,
      "return_msg": "正常响应"
 },
 "body": {
     "vm": {
       "id": "0081801",
       "name": "友宝在线六层富二代完鼎测试需要改动名称完鼎测试需要改动名称完",
       "address": "北京111111",
       "distance": "",
       "is_shop": false,
       "has_box": false,
       "has_meal": false,
       "lat": "116.480557",
       "lng": "39.960201",
       "vm_connected": true
    },
    "product": {
          "id": 10000870,
          "name": "双层咖啡杯",
          "oldPrice": 200,
          "price": 200,
          "expire_time": 1464856997,
          "pic": "http://vms.dev.uboxol.com/upload/box-tmp/m/10000870/10000870.jpg?t=1357177524",
          "num": 16
   },
   "tran_id": "100031290"
 }
}
```
### notifyOrder 扫码下单请求
```ruby
notify = Ubox.notify_order(tran_id: detail['body']['tran_id'],
                           retain_period: 300,
                           app_tran_id: Random.rand_str(32),
                           app_uid: Random.rand_str(32)
     )
```

```json
{"head":{
    "return_code":200, 
    "return_msg":"正常响应"
  }
}
```

### notifyPament 买取货码(支付结果通知)

```ruby
payment = Ubox.notify_payment(tran_id: detail['body']['tran_id'],
                                  pay_time: Time.now.to_i,
                                  app_current_time: Time.now.to_i,
                                  deliver_now: true)
```
#### 商品已售空
```json
{"head":{
    "return_code":410, 
    "return_msg":"该商品已售空"
 }
}
```

### getTradeOrderStatus 出货结果询问 

```ruby
status = Ubox.trade_order_status(tran_id: detail['body']['tran_id'])
```
#### 出货失败
```json
{"head":{
    "return_code":200, 
    "return_msg":"正常响应"
 }, 
 "body":{
    "code":500, 
    "msg":"出货失败"
 }
}
```

### searchVmList 搜索售货机接口

```ruby
list = Ubox.search_vm_list(keyword:'北京香颂')
```

```json
{
  "head": {
    "return_code": 200,
    "return_msg": "正常响应"
  },
  "body": {
    "node_list": [
      {
        "id": "1611",
        "name": "北京香颂",
        "address": "望京北京香颂224号楼306室",
        "distance": "",
        "is_shop": true,
        "has_box": true,
        "has_meal": false,
        "lat": "39.998533",
        "lng": "116.45923",
        "vm_connected": true
      }
    ],
    "has_more": false
  }
}
```

### productList 根据售货机获取商品列表

```ruby
products = Ubox.product_list(vmid: '0061029')
```

```json
{
  "head": {
    "return_code": 200,
    "return_msg": "正常响应"
  },
  "body": {
    "shelfs": [
      {
        "id": 1,
        "name": "热销",
        "url": "",
        "products": [
          19401,
          24605,
          19492,
          24602,
          19458,
          19450,
          19497,
          19461,
          19463,
          24601,
          19474
        ]
      },
      {
        "id": 113,
        "name": "百货",
        "url": "",
        "products": [
          19401,
          19450,
          19458,
          19461,
          19463,
          19474,
          19492,
          19497,
          24601,
          24602,
          24605
        ]
      }
    ],
    "products": [
      {
        "id": 19401,
        "name": "魅蓝伸缩飞机杯",
        "sName": "魅蓝伸缩飞机杯",
        "price": 39900,
        "oldPrice": 39900,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/19401/19401.jpg?t=20151117135023",
        "num": 1
      },
      {
        "id": 19450,
        "name": "品色国际帝王之器转珠棒",
        "sName": "品色国际帝王之器转珠棒",
        "price": 16800,
        "oldPrice": 16800,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/19450/19450.jpg?t=20151118130540",
        "num": 1
      },
      {
        "id": 19497,
        "name": "冈本skin纯淡香味3只装",
        "sName": "冈本skin纯淡香味",
        "price": 1200,
        "oldPrice": 1200,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/19497/19497.jpg?t=20151118140955",
        "num": 1
      },
      {
        "id": 19461,
        "name": "玩爆潮品震动水晶套飞毛腿",
        "sName": "玩爆潮品震动水晶套飞毛腿",
        "price": 4900,
        "oldPrice": 4900,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/19461/19461.jpg?t=20151118131354",
        "num": 1
      },
      {
        "id": 19492,
        "name": "MOVO女用提升欲望润滑液100ml",
        "sName": "MOVO女用提升欲望润滑",
        "price": 13800,
        "oldPrice": 13800,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/19492/19492.jpg?t=20151118140611",
        "num": 1
      },
      {
        "id": 24605,
        "name": "瑟诗芭比缕空露乳连体袜",
        "sName": "缕空露乳连体袜",
        "price": 9900,
        "oldPrice": 9900,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/24605/24605.jpg?t=20160519174238",
        "num": 1
      },
      {
        "id": 19463,
        "name": "玩爆潮品震动水晶套流星锤",
        "sName": "玩爆潮品震动水晶套流星锤",
        "price": 4900,
        "oldPrice": 4900,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/19463/19463.jpg?t=20151118131515",
        "num": 1
      },
      {
        "id": 24602,
        "name": "久兴20频狂舔魔舌震动器颗粒型",
        "sName": "狂舔魔舌震动器颗粒型",
        "price": 12800,
        "oldPrice": 12800,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/24602/24602.jpg?t=20160519173901",
        "num": 1
      },
      {
        "id": 19458,
        "name": "VNA藏帝男用延时喷剂15ml",
        "sName": "VNA藏帝男用延时喷剂",
        "price": 19900,
        "oldPrice": 19900,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/19458/19458.jpg?t=20151118131152",
        "num": 1
      },
      {
        "id": 24601,
        "name": "蒂贝女用振动棒潮吹蛇王",
        "sName": "潮吹蛇王",
        "price": 16800,
        "oldPrice": 16800,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/24601/24601.jpg?t=20160519173745",
        "num": 1
      },
      {
        "id": 19474,
        "name": "倍耐力男用延时喷剂",
        "sName": "倍耐力男用延时喷剂",
        "price": 3900,
        "oldPrice": 3900,
        "desc": "",
        "expire_time": 1464934974,
        "pic": "http://img.ubox.cn/box-tmp/m/19474/19474.jpg?t=20151118135030",
        "num": 1
      }
    ]
  }
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ubox. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

