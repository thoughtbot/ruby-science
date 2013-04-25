ExampleApp::Application.routes.draw do
  resources :completions, only: [:show]

  resources :questions, only: [:edit, :update] do
    resources :options, only: [:new, :create]
    resources :types, only: [:new, :create]
  end

  resources :invitations, only: [] do
    resources :users, only: [:new]
  end

  resources :surveys, only: [:new, :create, :index, :show] do
    resources :completions, only: [:create, :index]
    resources :invitations, only: [:create, :new]
    resources :questions, only: [:new, :create]
    resources :summaries, only: [:show]
  end

  resources :unsubscribes, only: [:new, :create]

  root to: 'surveys#index'
end
