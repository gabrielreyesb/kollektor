import { application } from "./application.js"

import AlertController from "./alert_controller.js"
import FilterController from "./filter_controller.js"
import SidebarController from "./sidebar_controller.js"
import DisplayController from "./display_controller.js"
import GenreFilterController from "./genre_filter_controller.js"

application.register("alert", AlertController)
application.register("filter", FilterController)
application.register("sidebar", SidebarController)
application.register("display", DisplayController)
application.register("genre-filter", GenreFilterController)
