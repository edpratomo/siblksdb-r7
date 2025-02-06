import { Controller } from "@hotwired/stimulus"
import _ from "lodash";

// Connects to data-controller="digit-grouping"
export default class extends Controller {
  static targets = [ "amount" ]

  connect() {
    this.separate = _.debounce(this.separate.bind(this), 500); // Debounce with 500ms delay
    console.log("Hello, Stimulus!", this.element)
  }

  separate() {
    if (!this.hasAmountTarget) {
      console.log("No amount target found!");
      return;
    }
    const value = this.amountTarget.value;
    const separated = value.replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,");
    this.amountTarget.value = separated;
  }
}
