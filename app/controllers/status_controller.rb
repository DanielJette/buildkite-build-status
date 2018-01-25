class StatusController < ApplicationController

	after_action :set_headers

	def show
		respond_to do |format|
			format.json {
				render :json => "{ Success }" 
			}
		end
	end

	protected
		def set_headers
			response.headers['Access-Control-Allow-Origin:'] = '*'
		end
end
