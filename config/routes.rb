Rails.application.routes.draw do
	namespace "api", defaults: {format: :json} do
		post '/metrics', to: "metrics#create"
	end
end
