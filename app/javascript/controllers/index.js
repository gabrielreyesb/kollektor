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

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Uncomment if you have controllers in the main javascript directory
// import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
// eagerLoadControllersFrom("../controllers", application)
