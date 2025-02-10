// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
window.bootstrap = bootstrap;

import "@fortawesome/fontawesome-free/js/all"

import "./add_jquery"
import "admin-lte"

import moment from "moment/dist/moment"
import "moment/dist/locale/id"
window.moment = moment;

require("tempusdominus-bootstrap-4");
import "datatables.net-bs4"
import "datatables.net-responsive-bs4";

require("./jquery.poshytip");

// console.log($.fn.datetimepicker);

document.addEventListener("turbo:load", () => {
  $('#reservationdatetime').datetimepicker({ icons: { time: 'far fa-clock' } });

  $('#datetimepicker1').datetimepicker({format: 'L', ignoreReadonly: true });

  $("#datatable_with_search").DataTable({
    "responsive": true, "lengthChange": false, "autoWidth": false,
    "searching": true, "paging": true, "ordering": true, "info": true
  });

  $('#datatable_plain').DataTable({
    "paging": true,
    "lengthChange": false,
    "searching": false,
    "ordering": true,
    "info": true,
    "autoWidth": false,
    "responsive": true,
  });
  
  $('#demo-basic').poshytip();

  // turbo interferes with the sidebar collapse, so we need to reinitialize it
  // $('[data-widget="treeview"]').Treeview('init'); // Reinitialize AdminLTE treeview
});

import toastr from "toastr"
window.toastr = toastr;
console.log("toastr loaded: " + window.toastr);
window.BootstrapDialog = require("bootstrap4-dialog/dist/js/bootstrap-dialog.min");
