// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "@fortawesome/fontawesome-free/js/all"

import "./add_jquery"
import "admin-lte"

import moment from "moment/dist/moment"
window.moment = moment;

import toastr from "toastr"
window.toastr = toastr;

require "tempusdominus-bootstrap-4/build/js/tempusdominus-bootstrap-4"
