Rails.application.routes.draw do
  # ---------------------------------------------------------------------------
  # Core (always-on) resources
  # ---------------------------------------------------------------------------
  resources :shortcuts
  resources :announcements
  resources :calendar_notes

  resources :gateways do
    member do
      post "webhook"
    end
  end

  resources :audit_logs, only: %i[index show destroy] do
    post "revert", to: "audit_logs#revert", on: :member
  end

  resources :hooks
  resources :reports do
    get "run", on: :member
  end
  resources :variables

  resources :teams do
    resources :memberships
  end

  resources :team_types
  resources :relationship_types

  resources :people do
    resources :memberships, only: %i[index new create destroy]
    resources :relationships, only: %i[new create destroy] do
      member do
        post "reverse"
      end
    end
    resource :user, only: %i[new create edit update]
    member do
      post "impersonate"
      get "calendar"
      get "statistics"
      get "relationships"
      get "recent_activity"
    end
    collection do
      post "stop_impersonating"
    end
  end

  resources :settings, only: %i[index] do
    post "update", on: :collection, as: "update"
  end

  resources :features, only: %i[index] do
    post "update", on: :collection, as: "update"
  end

  # ---------------------------------------------------------------------------
  # Badges feature
  # ---------------------------------------------------------------------------
  if GatherPack::Features.enabled?(:badges)
    resources :badges do
      resources :badge_assignments
    end
    resources :badge_types
  end

  # ---------------------------------------------------------------------------
  # Tokens feature
  # ---------------------------------------------------------------------------
  if GatherPack::Features.enabled?(:tokens)
    resources :tokens
  end

  # ---------------------------------------------------------------------------
  # Events & Calendar feature
  # ---------------------------------------------------------------------------
  if GatherPack::Features.enabled?(:events)
    resources :events do
      resources :checkins, except: %i[index]
      member do
        get "arrange"
        get "print"
        patch "field_update", to: "checkins#field_update"
      end
    end
    resources :calendar, only: %i[index] do
      collection do
        post "calendar", to: "calendar#calendar"
        get "calendar", to: "calendar#calendar"
      end
    end
    resources :checkin_fields
    resources :event_types
  end

  # ---------------------------------------------------------------------------
  # Time Tracking feature
  # ---------------------------------------------------------------------------
  if GatherPack::Features.enabled?(:time_tracking)
    get "time_kiosk", to: "time_kiosk#index"
    post "time_kiosk", to: "time_kiosk#index"
    patch "time_kiosk", to: "time_kiosk#index"

    resources :time_clock_periods do
      member do
        get "summary"
      end
    end
    resources :time_clock_punches, except: :show do
      collection do
        get "flagged"
        delete "bulk_destroy"
        patch "update_max_hours"
      end
    end
  end

  # ---------------------------------------------------------------------------
  # Ledger feature
  # ---------------------------------------------------------------------------
  if GatherPack::Features.enabled?(:ledger)
    resources :ledger_payments, only: %i[new create]
    resources :ledger_transfers, only: %i[new create]
    resources :ledger_entry_links
    resources :ledger_tags
    resources :ledgers do
      resources :ownerships, controller: "ledger_ownerships"
      resources :ledger_entries, except: %i[index] do
        member do
          post "split"
          post "unsplit"
        end
      end
    end
  end

  # ---------------------------------------------------------------------------
  # Budgets feature
  # ---------------------------------------------------------------------------
  if GatherPack::Features.enabled?(:budgets)
    resources :budgets
    resources :budget_periods
  end

  # ---------------------------------------------------------------------------
  # Mailboxes feature
  # ---------------------------------------------------------------------------
  if GatherPack::Features.enabled?(:mailboxes)
    resources :mailboxes do
      resources :mailbox_messages, except: %i[index]
    end
  end

  # ---------------------------------------------------------------------------
  # Pages feature
  # ---------------------------------------------------------------------------
  if GatherPack::Features.enabled?(:pages)
    resources :pages
  end

  # ---------------------------------------------------------------------------
  # Plugin-contributed routes
  # Each plugin feature may declare a routes_proc that is instance_exec'd here.
  # ---------------------------------------------------------------------------
  GatherPack::Features.all.select { |f| f.enabled? && f.routes_proc }.each do |feature|
    instance_exec(&feature.routes_proc)
  end

  # ---------------------------------------------------------------------------
  # Auth
  # ---------------------------------------------------------------------------
  if Settings[:local_signup]
    devise_for :users, controllers: { omniauth_callbacks: "omniauth", registrations: "users/registrations" }
  else
    devise_for :users, controllers: { omniauth_callbacks: "omniauth" }, skip: :registrations
  end

  # ---------------------------------------------------------------------------
  # Misc
  # ---------------------------------------------------------------------------
  get "/setup" => "welcome#setup", :as => :setup
  get "search" => "search#index", :as => :search
  get "search/combo" => "search#combo", :as => :combo_search

  mount MissionControl::Jobs::Engine, at: "/jobs"

  get "up" => "rails/health#show", :as => :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest

  root "welcome#index"
end
