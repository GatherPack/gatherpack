Rails.application.routes.draw do
  resources :checkin_fields
  resources :mailboxes do
    resources :mailbox_messages, except: %i[ index ]
  end
  resources :time_clock_periods
  resources :time_clock_punches, except: :show
  resources :audit_logs, only: %i[ index show destroy ] do
    post "revert", to: "audit_logs#revert", on: :member
  end
  resources :transactions, only: %i[ index create ]
  resources :accounts
  resources :pages
  resources :tokens
  resources :hooks
  resources :badges do
    resources "badge_assignments", only: %i[ index ]
  end
  resources :badge_types
  resources :events do
    resources :checkins, except: %i[ index ]
    collection do
      post "calendar", to: "events#calendar"
      get "calendar", to: "events#calendar"
    end
  end
  resources :event_types
  resources :announcements
  resources :reports do
    get "run", on: :member
  end
  resources :variables
  resources :teams do
    resources :memberships, only: %i[ index update destroy ]
  end
  resources :settings, only: %i[ index ] do
    post "update", on: :collection, as: "update"
  end
  resources :team_types
  resources :relationship_types
  resources :people do
    resources :relationships, only: %i[ new create destroy ]
    resource :user, only: %i[ new create edit update ]
  end

  if Settings[:local_signup]
    devise_for :users, controllers: { omniauth_callbacks: "omniauth", registrations: "users/registrations" }
  else
    devise_for :users, controllers: { omniauth_callbacks: "omniauth" }, skip: :registrations
  end

  get "/setup" => "welcome#setup", as: :setup
  get "search" => "search#index", as: :search

  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "welcome#index"
end
