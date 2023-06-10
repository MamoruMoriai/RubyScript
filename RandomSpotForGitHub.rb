require 'net/http'
require 'uri'
require 'json'

def get_json(url)

  uri = URI.parse(URI.escape(url))

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  param = {}
  param['X-API-KEY'] = 'ここにAPIキー'

  req = Net::HTTP::Get.new(uri.request_uri, param)
  res = https.request(req)

  json = res.body
  result = JSON.parse(json)

end

puts "このプログラムではあなたの行き先をランダムで選択します。"
puts "行きたい都道府県を入力してください。\n"
print ">> "
str = gets.chomp

prefecture = get_json("https://opendata.resas-portal.go.jp/api/v1/prefectures")
prefNumber = 0
prefecture["result"].each do |val|
  if val["prefName"] == str then
    prefNumber = val["prefCode"]
  end
end

city = get_json("https://opendata.resas-portal.go.jp/api/v1/cities?prefCode=#{prefNumber}")

#prefecture["result"].each do |val|
#  puts val["prefName"]
#end

cnt = city["result"].length
target = Random.new.rand(cnt)
id = []
city["result"].each do |val|
  id.append(val["cityCode"])
end

city["result"].each do |val|
  if val["cityCode"] == id[target] then
    print "あなたの行き先は...\n", ">> ", val["cityName"], "\n"
  end
end
