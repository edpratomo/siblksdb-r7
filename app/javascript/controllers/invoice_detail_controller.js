import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="invoice-detail"
export default class extends Controller {
  static targets = [ "modal" ]

  connect() {
    console.log("Connected to invoice-detail controller")
  }

  open({ params: { invoice}}) {
    // console.log("boostrapDialog: " + BootstrapDialog);
    console.log("invoice_id: " + invoice);

    var dialogInstance1 = new BootstrapDialog({
      size: BootstrapDialog.SIZE_WIDE,
      title: 'Invoice: ' + invoice,
      buttons: [
        {
          id: 'btn-1',
          label: 'Close',
          cssClass: 'btn-default',
          action: function(dialogItself){
                    dialogItself.close();
                  }
        },
      ],
      message: $('<div></div>').load('/invoices/' + invoice + '.html?modal=1')
    });
  
    dialogInstance1.realize();

    var btn1 = dialogInstance1.getButton('btn-1');
    $(btn1).removeClass("btn-block");

    //alert($(btn1).css("class"))
    dialogInstance1.open();
  }
}
