Rails.application.routes.draw do
  resources :payments
  resources :fees
  resources :admissions
  resources :invoices
  
  get "home/index"
  root "home#index"
  
  resources :admission_fees, :controller => "fees", :type => "AdmissionFee"
  resources :reg_course_fees, :controller => "fees", :type => "RegCourseFee"
  resources :int_course_fees, :controller => "fees", :type => "IntCourseFee"
  resources :ext_course_fees, :controller => "fees", :type => "ExtCourseFee"
  resources :book_uniform_fees, :controller => "fees", :type => "BookUniformFee"

  devise_for :users, skip: [:registrations]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
