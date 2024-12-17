import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"];

  connect() {
    console.log("Filter controller connected!");
  }

  submit() {
    //const url = this.formTarget.action;
    const url = new URL(this.formTarget.action, window.location.origin);
    //const data = new FormData(this.formTarget);

    const params = new URLSearchParams(new FormData(this.formTarget));
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
}
