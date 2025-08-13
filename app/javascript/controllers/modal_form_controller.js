import { Controller } from "@hotwired/stimulus"

// This controller closes a Bootstrap modal when a Turbo-enabled form inside it is successfully submitted.
export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.handleTurboSubmitEnd = this.handleTurboSubmitEnd.bind(this)
    document.addEventListener("turbo:submit-end", this.handleTurboSubmitEnd)
  }

  disconnect() {
    document.removeEventListener("turbo:submit-end", this.handleTurboSubmitEnd)
  }

  handleTurboSubmitEnd(event) {
    // Only close if the form is inside this modal
    if (!this.hasModalTarget) return
    const modalElement = this.modalTarget
    if (modalElement.contains(event.target)) {
      // Only close on successful response (status 2xx or 3xx)
      if (event.detail.success) {
        // Bootstrap 5 modal close
        const modal = bootstrap.Modal.getInstance(modalElement) || new bootstrap.Modal(modalElement)
        modal.hide()
      }
    }
  }
}
