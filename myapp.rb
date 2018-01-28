require 'sinatra'
require 'net/http'
require 'json'

after do
	response['Access-Control-Allow-Origin'] = '*'
	response['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
end

BUILDKITE_URL = "https://badge.buildkite.com/"

private def fetch_status(id, branch)
	uri = URI("#{BUILDKITE_URL}#{id}.json?branch=#{branch}")

	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	response = http.get(uri)
	json = JSON.parse(response.body)

	if json['status'] == 'passing'
		'green'
	else
		'red'
	end
end

get '/status' do
	if(!params.has_key?(:id))
		halt 500, "500: BuildKite ID required"
	end

	branch = params[:branch] || 'master'
	fetch_status(params[:id], branch)
end

get '/image' do
	if(!params.has_key?(:id))
		halt 500, "500: BuildKite ID required"
	end

	id = params[:id]
	platform = params[:platform]  || 'android'
	branch = params[:branch] || 'master'

	"#{platform}-#{fetch_status(id, branch)}.png"
end


get '/badge' do
	if(!params.has_key?(:id))
		halt 500, "500: BuildKite ID required"
	end

	id = params[:id]
	branch = params[:branch] || 'master'

	"#{BUILDKITE_URL}#{id}.svg?branch=#{branch}"
end