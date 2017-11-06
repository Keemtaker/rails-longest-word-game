Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'game', to: 'words#game'
  get 'score', to: 'words#score'
  root to: 'words#game'
end
