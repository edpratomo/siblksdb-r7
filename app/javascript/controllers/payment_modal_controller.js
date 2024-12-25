import { Controller } from "@hotwired/stimulus"
//import bootstrapDialog from "bootstrap4-dialog"

// Connects to data-controller="payment-modal"
export default class extends Controller {
  connect() {
    console.log("payment_modal_controller connected " + this.element)
  }

  open({ params: { invoice}}) {
    console.log("boostrapDialog: " + BootstrapDialog);
    console.log("invoice_id: " + invoice);

    BootstrapDialog.show({
      size: BootstrapDialog.SIZE_WIDE,
      buttons: [
        {
          label: 'Tutup',
          cssClass: 'btn-warning',
          icon: 'glyphicon glyphicon-ban-circle',
          action: function(dialogItself) {
                    dialogItself.setData("button", "Tutup")
                    dialogItself.close();
                  }
        }
      ],
      message: $('<div></div>').load('/payments/' + invoice + '/new')
    });
  
  }
}
