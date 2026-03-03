Rails.application.routes.draw do
    resources :books, only: [:index, :show] do
        post 'reserve', on: :member
    end
end