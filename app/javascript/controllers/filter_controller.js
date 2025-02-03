import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["filterParams", "datePicker", "search"]
  //static targets = ["datePicker"]
  connect() {
    console.log("Filter controller connected!");
  }
  
  submit() {
    //const formElement = this.filterParamsTarget.form;
    var formElement;

    if (this.hasFilterParamsTarget) {
      formElement = this.filterParamsTarget.form;
    } else if (this.hasDatePickerTarget) {
      formElement = this.datePickerTarget.form;
    }

    //const url = this.formTarget.action;
    const url = new URL(formElement.action, window.location.origin);
    //const data = new FormData(this.formTarget);

    const params = new URLSearchParams(new FormData(formElement));
    url.search = params.toString();  // Add form data as query string

    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

    fetch(url, {
      method: "GET",
      headers: {
        "Accept": "text/javascript",
        "X-CSRF-Token": csrfToken
      }
    })
    .then(response => response.text())
    .then(html => {
      document.getElementById("filterrific_results").innerHTML = html;
    });
  }

  clear() {
    this.searchTarget.value = ""; // Clear the input field
    this.searchTarget.focus(); // Optionally focus back on the input
    const formElement = this.searchTarget.form;
    this.doSubmit(formElement);
  }

  doSubmit(formElement) {
    //const url = this.formTarget.action;
    const url = new URL(formElement.action, window.location.origin);
    //const data = new FormData(this.formTarget);

    const params = new URLSearchParams(new FormData(formElement));
    url.search = params.toString();  // Add form data as query string

    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

    fetch(url, {
      method: "GET",
      headers: {
        "Accept": "text/javascript",
        "X-CSRF-Token": csrfToken
      }
    })
    .then(response => response.text())
    .then(html => {
      document.getElementById("filterrific_results").innerHTML = html;
    });
  }

  submitWithDelay(event) {
    console.log("submitWithDelay");
    // Store the reference to the current element
    const target = event.target;

    // Clear only this element's timeout
    clearTimeout(target.timeout);

    // Assign a new timeout specific to this element
    target.timeout = setTimeout(() => {
      var formElement = target.form;
      console.log("delayed submit");
      this.doSubmit(formElement);
    }, 1000);
  }
}
