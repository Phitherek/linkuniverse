Rails.application.routes.draw do # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  root :to => "collections#index"

  resources :users, only: [:show, :edit, :update] do
    collection do
      get 'login'
      post 'login'
      get 'register'
      post 'register'
      delete 'logout'
      get 'me'
      get 'edit_me'
      patch 'update_me'
      get 'destroy_me'
      delete 'do_destroy_me'
      patch 'accept_membership'
      delete 'cancel_membership'
      get 'activate'
      get 'start_password_reset'
      post 'do_start_password_reset'
      get 'reset_password'
      post 'do_reset_password'
      get 'resend_activation_email'
      post 'do_resend_activation_email'
    end
  end

  resources :collections do
    collection do
      get 'own'
      get 'shared'
      get 'public'
      get 'own_list'
      get 'shared_list'
      get 'public_list'
    end
    member do
      patch 'upvote'
      patch 'downvote'
      post 'add_participant'
      patch 'update_participant'
      delete 'destroy_participant'
      delete 'cancel_participation'
    end
    resources :links, except: [:index] do
      member do
        post 'add_comment'
        get 'edit_comment'
        get 'cancel_edit_comment'
        get 'comment_count'
        patch 'update_comment'
        delete 'destroy_comment'
        patch 'upvote'
        patch 'downvote'
      end
      collection do
        get 'title_on_the_fly'
      end
    end
  end
end
