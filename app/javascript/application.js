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

require("tempusdominus-bootstrap-4");
import "datatables.net-bs4"
import "datatables.net-responsive-bs4";

// console.log($.fn.datetimepicker);

document.addEventListener("turbo:load", () => {
  $('#reservationdatetime').datetimepicker({ icons: { time: 'far fa-clock' } });

  $('#datetimepicker1').datetimepicker({ icons: { time: 'far fa-clock' } });

  //Date picker
  $('#admission_after').datetimepicker({format: 'L'});
  $('#admission_before').datetimepicker({format: 'L'});

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

import toastr from "toastr"

document.addEventListener("turbo:load", () => {
  window.toastr = toastr;
});

