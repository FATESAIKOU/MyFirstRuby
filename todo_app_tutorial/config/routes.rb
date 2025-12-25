Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # ============================================
  # Todo 資源路由
  # ============================================
  # 這會產生以下 7 個路由：
  #   GET    /todos          -> todos#index   (列表)
  #   GET    /todos/new      -> todos#new     (新增表單)
  #   POST   /todos          -> todos#create  (建立)
  #   GET    /todos/:id      -> todos#show    (顯示)
  #   GET    /todos/:id/edit -> todos#edit    (編輯表單)
  #   PATCH  /todos/:id      -> todos#update  (更新)
  #   DELETE /todos/:id      -> todos#destroy (刪除)
  resources :todos

  # 設定首頁為 Todo 列表
  root "todos#index"
end
