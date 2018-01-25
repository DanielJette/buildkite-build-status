require 'net/http'
require 'json'

class StatusController < ApplicationController

	after_action :set_headers

	def show

		id = request.query_parameters['id']
		platform = request.query_parameters['platform']  || 'android'
		url = 'https://badge.buildkite.com/' + id + '.json'
		uri = URI(url)

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		response = http.get(uri)

		json = JSON.parse(response.body)

		result = json['status']

		tint = if result == 'passing'
			'green'
		else
			'red'
		end

		image = platform + "-" + tint + ".png"

		respond_to do |format|
			format.json {
				render :json => image 
			}
		end
	end

	protected
		def set_headers
			response.headers['Access-Control-Allow-Origin:'] = '*'
		end
end
