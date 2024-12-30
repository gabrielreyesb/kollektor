// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "./application"
import FilterController from "./filter_controller"
import AlertController from "./alert_controller"
import SidebarController from "./sidebar_controller"
import DisplayController from "./display_controller"
import GenreFilterController from "./genre_filter_controller"

application.register("filter", FilterController)
application.register("alert", AlertController)
application.register("sidebar", SidebarController)
application.register("display", DisplayController)
application.register("genre-filter", GenreFilterController)
