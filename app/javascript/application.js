// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "./controllers/index.js"
import * as bootstrap from "bootstrap"

Turbo.session.drive = false