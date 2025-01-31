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

// console.log($.fn.datetimepicker);

document.addEventListener("turbo:load", () => {
  $('#reservationdatetime').datetimepicker({ icons: { time: 'far fa-clock' } });

  $('#datetimepicker1').datetimepicker({format: 'L', ignoreReadonly: true });

  //Date picker
  /*
  $('#admission_after').datepicker({format: 'L',
    onSelect: function(dateText, inst) {
      console.log("datetimepicker AFTER selected");
      $(this).parents("form").submit();
    }
  });
  
  $('#admission_before').datetimepicker({format: 'L',
    onSelect: function(dateText, inst) {
      console.log("datetimepicker BEFORE selected");
      $(this).parents("form").submit();
    }
  });
  */
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
window.toastr = toastr;
window.BootstrapDialog = require("bootstrap4-dialog/dist/js/bootstrap-dialog.min");

/*
console.log(window.bootstrap);
console.log(window.toastr);
console.log(window.BootstrapDialog);
*/
