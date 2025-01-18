import { application } from "./application"

import AlertController from "./alert_controller"
import FilterController from "./filter_controller"
import SidebarController from "./sidebar_controller"
import DisplayController from "./display_controller"
import GenreFilterController from "./genre_filter_controller"
import MusicbrainzController from "./musicbrainz_controller"
import InfiniteScrollController from "./infinite_scroll_controller"

application.register("alert", AlertController)
application.register("filter", FilterController)
application.register("sidebar", SidebarController)
application.register("display", DisplayController)
application.register("genre-filter", GenreFilterController)
application.register("musicbrainz", MusicbrainzController)
application.register("infinite-scroll", InfiniteScrollController)
