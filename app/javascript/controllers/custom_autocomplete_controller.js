import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="custom-autocomplete"
export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log("✅ CustomAutocomplete Controller Connected!");

    const eventType = "autocomplete.change";
    this.inputTarget.addEventListener(eventType, (event) => {
      console.log(`${eventType} event emitted`, event)
    });
  }

  handleSelect(event) {
    const selectedValue = event.detail.value;
    console.log("🎯 Selected:", selectedValue);

    window.location.href = '/admissions/' + selectedValue + '/edit';
  }
}
