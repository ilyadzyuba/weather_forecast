# encoding: utf-8
#
# Программа «Прогноз погоды» Версия 1.0
#
# Данные берем из XML метеосервиса
# http://www.meteoservice.ru/content/export.html
#
require "net/http"
require "uri"
require "rexml/document"
# Облачность с сайта метеосервиса
CLOUDINESS = %w(Ясно Малооблачно Облачно Пасмурно).freeze
# создаем объект-адрес где лежит погода Москвы виде XML
uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/37.xml")

# найти идентификатор своего города можете здесь:
# https://www.meteoservice.ru/content/export

# Отправляем запрос по адресу uri и сохраняем результат в переменную response
response = Net::HTTP.get_response(uri)

# парсим полученный XML
doc = REXML::Document.new(response.body)

# собираем параметры
city_name = URI.unescape(doc.root.elements['REPORT/TOWN'].attributes['sname'])
time = Time.now
forecast = doc.root.elements['REPORT/TOWN/FORECAST']
min_temp = forecast.elements['TEMPERATURE'].attributes['min']
max_temp = forecast.elements['TEMPERATURE'].attributes['max']
min_wet = forecast.elements['RELWET'].attributes['min']
max_wet = forecast.elements['RELWET'].attributes['max']
wind = forecast.elements['WIND'].attributes['max']
clouds_index = forecast.elements['PHENOMENA'].attributes['cloudiness'].to_i
clouds = CLOUDINESS[clouds_index]

puts "Сейчас #{time}, погода в городе #{city_name}:"
puts "Температура от #{min_temp} до #{max_temp} градусов"
puts "Ветер до #{wind} м/с"
puts "Влажность от #{min_wet} до #{max_wet} %"
puts clouds
