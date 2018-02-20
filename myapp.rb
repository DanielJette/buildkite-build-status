require 'sinatra'
require 'net/http'
require 'json'

after do
	response['Access-Control-Allow-Origin'] = '*'
	response['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
end

BUILDKITE_URL = "https://badge.buildkite.com/"

private def fetch_status(id, branch, step = nil)
	uri = URI("#{BUILDKITE_URL}#{id}.json?branch=#{branch}#{step}")

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

private def get_step()
	if (params.has_key?(:step))
		"&step=#{params[:step].gsub(' ','%20')}"
	end
end

get '/full' do
	if(!params.has_key?(:id))
		halt 500, "500: BuildKite ID required"
	end

	branch = params[:branch] || 'master'
	step = get_step()
	status = fetch_status(params[:id], branch, step)
	badge  = "#{BUILDKITE_URL}#{params[:id]}.svg?branch=#{branch}#{step}"

	"{ status: \"#{status}\", badge: \"#{badge}\" }"
end



get '/status' do
	if(!params.has_key?(:id))
		halt 500, "500: BuildKite ID required"
	end

	branch = params[:branch] || 'master'
	fetch_status(params[:id], branch, get_step())
end

get '/badge' do
	if(!params.has_key?(:id))
		halt 500, "500: BuildKite ID required"
	end

	id = params[:id]
	branch = params[:branch] || 'master'
	"#{BUILDKITE_URL}#{id}.svg?branch=#{branch}#{get_step()}"
end