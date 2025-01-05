# Pin npm packages by running ./bin/importmap
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# Pin application
pin "application", preload: true

# Pin Bootstrap
pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.3.2/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/dist/esm/index.js"

# Pin controllers explicitly with .js extension
pin "controllers/application", to: "controllers/application.js", preload: true
pin "controllers/alert_controller", to: "controllers/alert_controller.js", preload: true
pin "controllers/filter_controller", to: "controllers/filter_controller.js", preload: true
pin "controllers/sidebar_controller", to: "controllers/sidebar_controller.js", preload: true
pin "controllers/display_controller", to: "controllers/display_controller.js", preload: true
pin "controllers/genre_filter_controller", to: "controllers/genre_filter_controller.js", preload: true
