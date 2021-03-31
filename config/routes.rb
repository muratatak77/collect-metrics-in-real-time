Rails.application.routes.draw do
	namespace "api", defaults: {format: :json} do
		post '/metrics', to: "metrics#create"
		get '/metrics', to: "metrics#index"
		resources :thresholds
		get '/alert_update', to: "alerts#alert_update"
	end
end
