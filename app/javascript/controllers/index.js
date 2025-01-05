import { application } from "controllers/application"

import AlertController from "controllers/alert_controller.js"
import FilterController from "controllers/filter_controller.js"
import SidebarController from "controllers/sidebar_controller.js"
import DisplayController from "controllers/display_controller.js"
import GenreFilterController from "controllers/genre_filter_controller.js"

application.register("alert", AlertController)
application.register("filter", FilterController)
application.register("sidebar", SidebarController)
application.register("display", DisplayController)
application.register("genre-filter", GenreFilterController)
