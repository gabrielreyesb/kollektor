# Pin npm packages by running ./bin/importmap

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# Pin your custom JavaScript modules
pin "application", preload: true
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.2/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"

# Pin all controllers
pin "controllers", to: "controllers/index.js"
pin "controllers/application", to: "controllers/application.js"
pin "controllers/alert_controller", to: "controllers/alert_controller.js"
pin "controllers/filter_controller", to: "controllers/filter_controller.js"
pin "controllers/sidebar_controller", to: "controllers/sidebar_controller.js"
pin "controllers/display_controller", to: "controllers/display_controller.js"
pin "controllers/genre_filter_controller", to: "controllers/genre_filter_controller.js"
