import { Controller } from "@hotwired/stimulus"

// Opens a shared Bootstrap modal to confirm a destructive delete.
// No Bootstrap JS import needed — uses the hidden trigger button's data-bs-toggle.
// On any link or button add:
//   data-controller="confirm-delete"
//   data-action="click->confirm-delete#open"
// For links, the href is used as the delete URL automatically.
// For buttons without an href, supply data-confirm-delete-url-value.
// Optional: data-confirm-delete-message-value overrides the modal body text.
// Optional: data-confirm-delete-redirect-to-value sets where to go after deletion.
export default class extends Controller {
  static values = { url: String, message: String, redirectTo: String }

  open(event) {
    event.preventDefault()
    const url = this.hasUrlValue ? this.urlValue : this.element.href
    document.getElementById("confirm-delete-form").action = url
    document.getElementById("confirm-delete-redirect-to").value = this.hasRedirectToValue ? this.redirectToValue : ""
    document.getElementById("confirm-delete-modal-message").textContent =
      this.hasMessageValue ? this.messageValue : "Are you sure you want to delete this?"
    document.getElementById("confirm-delete-trigger").click()
  }
}
