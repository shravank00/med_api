Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # Patient routes
  resources :patients, only: [:index, :show, :create, :update] do
    collection do
      get 'search'
    end
  end

  # Coverage routes
  resources :coverages, only: [:index, :show, :create] do
    collection do
      get 'search'
    end
  end

  # Practitioner routes
  resources :practitioners, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  # Location routes
  resources :locations, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  # DocumentReference routes
  resources :document_references, only: [:index, :show] do
    collection do
      get 'search'
      get 'ccda_and_visit_notes'
    end
  end

  # Appointment routes
  resources :appointments, only: [:index, :show, :create, :update] do
    collection do
      get 'search'
    end
  end

  # Slot routes
  resources :slots, only: [] do
    collection do
      get 'search'
    end
  end

  # MedicationStatement routes
  resources :medication_statements, only: [:index, :show, :create, :update] do
    collection do
      get 'search'
    end
  end

  # AllergyIntolerance routes
  resources :allergy_intolerances, only: [:index, :show, :create, :update] do
    collection do
      get 'search'
    end
  end

  # Condition routes
  resources :conditions, only: [:index, :show, :create, :update] do
    collection do
      get 'search'
    end
  end

  # FamilyMemberHistory routes
  resources :family_member_histories, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  # Encounter routes
  resources :encounters, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  # ChargeItem routes
  resources :charge_items, only: [:index, :show, :create] do
    collection do
      get 'search'
    end
  end

  # Account routes
  resources :accounts, only: [] do
    collection do
      get 'search'
    end
  end

  # RelatedPerson routes
  resources :related_people, only: [:index, :show]

  # ServiceRequest routes
  resources :service_requests, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  # DiagnosticReport routes
  resources :diagnostic_reports, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  # Task routes
  resources :tasks, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  # Composition routes
  resources :compositions, only: [:create]

  # Organization routes
  resources :organizations, only: [:index, :show, :create] do
    collection do
      get 'search'
    end
  end

  # InsurancePlan routes
  resources :insurance_plans, only: [:index, :show] do
    collection do
      get 'search'
    end
  end
end
