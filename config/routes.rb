Rails.application.routes.draw do
	root to: redirect('/requisitions')

  resources :orders
  resources :requisitions do
  	collection do
  		get 'tasks'
  	end
  	member do
  		get 'approve'
  		get 'received'
  	end	
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
