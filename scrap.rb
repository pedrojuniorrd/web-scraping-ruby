require 'open-uri'
require 'nokogiri'
require 'httparty'
require 'nice_http'
require 'pry'
require 'pp'

class Nagios

    def getData

        uri = URI.parse("http://{host}/nagios/cgi-bin/status.cgi?limit=100&host=all&servicestatustypes=16&hoststatustypes=15")

        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        request.basic_auth("{user}", "{psk}")
        response = http.request(request)
        html = response.body
        doc = Nokogiri::HTML(html)
        #table = doc.at('.statusBGCRITICAL')
        status = doc.css('.status').css('.statusBGCRITICAL').css('a')
        #binding.pry

        hostNames = []
        serviceNames = []

        status.each do |dados|
            #host
            hostname =  dados.attribute('href').value
            inicioHost = '&host='
            fimHost = '&service='
            regexHost = hostname[/#{inicioHost}(.*?)#{fimHost}/m, 1]
            hostNames << regexHost
            #services
            inicioService = 'service='
            fimService = ''
            regexService = hostname[/#{inicioService}(.*?$)/m,1]
            serviceNames << regexService
                   
            #binding.pry
        end 
        hash =  Hash[hostNames.zip serviceNames]
        File.write('C:\Dev\PHP\CRUD\teste.txt',hash)
        pp (hash)             
    end  
end

dados = Nagios.new
dados.getData


