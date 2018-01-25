require 'net/http'
require 'json'

class StatusController < ApplicationController

	after_action :set_headers

	def show

		id = request.query_parameters['id']
		url = 'https://badge.buildkite.com/' + id + '.json'
		uri = URI(url)

		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		response = http.get(uri)

		json = JSON.parse(response.body)

		respond_to do |format|
			format.json {
				render :json => json 
			}
		end
	end

	protected
		def set_headers
			response.headers['Access-Control-Allow-Origin:'] = '*'
		end
end
