class StatusController < ApplicationController

	def show
		respond_to do |format|
			format.json { render :json => "{ Success }" }
		end
	end
end
