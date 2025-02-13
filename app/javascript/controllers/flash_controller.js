import { Controller } from "@hotwired/stimulus"
import toastr from "toastr"

// Connects to data-controller="flash"
export default class extends Controller {
  connect() {
    let type = this.element.dataset.flashType;
    let message = this.element.dataset.flashMessage;

    console.log("flash_controller: " + type + " - " + message);
    console.log("toastr: " + toastr);
    toastr[type](message);
  }
}
