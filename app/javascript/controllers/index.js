import { application } from "controllers/application"

import AlertController from "controllers/alert_controller"
import FilterController from "controllers/filter_controller"
import SidebarController from "controllers/sidebar_controller"
import DisplayController from "controllers/display_controller"
import GenreFilterController from "controllers/genre_filter_controller"

application.register("alert", AlertController)
application.register("filter", FilterController)
application.register("sidebar", SidebarController)
application.register("display", DisplayController)
application.register("genre-filter", GenreFilterController)
