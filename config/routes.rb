Socializer::Engine.routes.draw do
  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: [:get, :post]
  match "/signin", to: "sessions#new", as: :signin, via: :get
  match "/signout", to: "sessions#destroy", as: :signout, via: [:get, :delete]

  get "/activities/:id/comment", to: "comments#new", as: :comment_activity

  resources :activities, only: [:index, :destroy] do
    resources :activities, only: [:index], controller: "activities/activities"

    member do
      # Audiences
      get "audience", to: "activities/audiences#index"

      # Likes
      get "likes", to: "activities/likes#index"
      post "like", to: "activities/likes#create"
      delete "unlike", to: "activities/likes#destroy"

      # Shares
      get "share", to: "activities/shares#new", as: "new_share"
      post "share", to: "activities/shares#create", as: "create_share"
    end
  end

  resources :audience_lists,  only: [:index]
  resources :authentications, only: [:index, :destroy]

  resources :circles do
    resources :activities, only: [:index], controller: "circles/activities"

    collection do
      get "contacts", to: "circles/contacts#index"
      get "contact_of", to: "circles/contact_of#index"
      get "suggestions", to: "circles/suggestions#index"
    end
  end

  # Not a good idea to create comments that don"t belong to something else
  resources :comments, only: [:new, :create, :edit, :update, :destroy]

  namespace :groups do
    get "joinable", to: "joinable#index"
    get "memberships", to: "memberships#index"
    get "ownerships", to: "ownerships#index"
    get "pending_invites", to: "pending_invites#index"
    get "public", to: "public#index"
    get "restricted", to: "restricted#index"
  end

  resources :groups do
    resources :activities, only: [:index], controller: "groups/activities"

    member do
      post "invite/:person_id", to: "groups/invitations#create", as: :invite_to
    end
  end

  resources :memberships, only: [:create, :destroy] do
    member do
      post "confirm", to: "memberships/confirm#create"
      delete "decline", to: "memberships/decline#destroy"
    end
  end

  resources :notes, except: [:index, :show]
  resources :notifications, only: [:index, :show]

  # TODO: Enable shallow routes
  resources :people, only: [:index, :show, :edit, :update] do
    resources :activities, only: [:index], controller: "people/activities"

    resources :person_addresses, except: [:index, :show],
                                 controller: "people/addresses",
                                 path: "addresses"

    # TODO: See if this works with namespaced models
    # resources :addresses, except: [:index, :show],
    #                       controller: "people/addresses"

    resources :contributions, only: [:create, :update, :destroy],
                              controller: "people/contributions"

    resources :educations, only: [:create, :update, :destroy],
                           controller: "people/educations"

    resources :employments, only: [:create, :update, :destroy],
                            controller: "people/employments"

    resources :links, only: [:create, :update, :destroy],
                      controller: "people/links"

    resources :phones, only: [:create, :update, :destroy],
                       controller: "people/phones"

    resources :places, only: [:create, :update, :destroy],
                       controller: "people/places"

    resources :profiles, only: [:create, :update, :destroy],
                         controller: "people/profiles"

    member do
      get "likes", to: "people/likes#index"
      get "messages/new", to: "people/messages#new"
    end
  end

  resources :ties, only: [:create, :destroy]

  # Example root that gets defined for a logged in user
  # get "/",
  #     to: "activities#index",
  #     constraints: -> request { request.cookies.key?("user_id").present? }
  #
  root to: "pages#index"
end
