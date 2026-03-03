Rails.application.routes.draw do
  resources :books, only: %i[index show] do
    post 'reserve', on: :member
  end
end
