// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import "@fortawesome/fontawesome-free/js/all"

import "./add_jquery"
import "admin-lte"

import moment from "moment/dist/moment"
import "moment/dist/locale/id"
window.moment = moment;

import toastr from "toastr"
window.toastr = toastr;

require("tempusdominus-bootstrap-4");
import "datatables.net-bs4"
import "datatables.net-responsive-bs4";

// console.log($.fn.datetimepicker);

document.addEventListener("turbo:load", () => {
  $('#reservationdatetime').datetimepicker({ icons: { time: 'far fa-clock' } });

  $('#example2').DataTable({
    "paging": true,
    "lengthChange": false,
    "searching": false,
    "ordering": true,
    "info": true,
    "autoWidth": false,
    "responsive": true,
  });
  
});

