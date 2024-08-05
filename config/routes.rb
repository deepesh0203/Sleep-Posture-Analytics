Rails.application.routes.draw do
  get 'breathing_rate/index'
  get 'breathing_rate/calculate'
  get 'video_classification/index'
  get 'video_classification/classify'
  get 'image_classification/index'
  get 'image_classification/classify'
  get 'welcome/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root 'welcome#index'
  get '/image_classification', to: 'image_classification#index'
  post '/image_classification/classify', to: 'image_classification#classify'
  get 'tmp/:path', to: 'image_classification#serve_tmp_image', constraints: { path: /.+/ }
  post 'image_classification/classify', to: 'image_classification#classify'
  get 'image_classification/serve_tmp_image', to: 'image_classification#serve_tmp_image'

  get '/video_classification', to: 'video_classification#index'
  post '/video_classification/classify', to: 'video_classification#classify'

  get '/breathing_rate', to: 'breathing_rate#index'
  post 'breathing_rate/generate_plot', to: 'breathing_rate#generate_plot'
  get '/breathing_rate/plot', to: 'breathing_rate#plot'

  resources :breathing_rate, only: [:index] do
    collection do
      post :generate_plot
      get :plot_image
    end
  end
  # Defines the root path route ("/")
  # root "posts#index"
end
