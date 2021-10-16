Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do 
      post "/authenticate", to: "v1/users#login"
      post "/authorize", to: "v1/users#get_user"
      
      post "/users", to: "v1/users#create" #for debugging purposes
      get  "/users", to: "v1/users#index"
  end
end
