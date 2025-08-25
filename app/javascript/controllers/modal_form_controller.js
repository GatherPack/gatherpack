import { Controller } from "@hotwired/stimulus"

// This controller closes a Bootstrap modal when a Turbo-enabled form inside it is successfully submitted.
export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.handleTurboSubmitEnd = this.handleTurboSubmitEnd.bind(this)
    document.addEventListener("turbo:submit-end", this.handleTurboSubmitEnd)

    this.handleLinkClick = this.handleLinkClick.bind(this)
    if (this.hasModalTarget) {
      this.modalTarget.addEventListener("click", this.handleLinkClick)
    }
  }

  disconnect() {
    document.removeEventListener("turbo:submit-end", this.handleTurboSubmitEnd)
    if (this.hasModalTarget) {
      this.modalTarget.removeEventListener("click", this.handleLinkClick)
    }
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

  async handleLinkClick(event) {
    const link = event.target.closest("a[data-turbo-method]");
    if (!link) return;
    const method = link.getAttribute("data-turbo-method");
    if (method !== "post" && method !== "patch") return;

    event.preventDefault();

    // Use Turbo to perform the request
    const url = link.getAttribute("href");
    const headers = { "Accept": "text/vnd.turbo-stream.html, text/html, application/xhtml+xml" };
    const token = document.querySelector('meta[name="csrf-token"]')?.content;
    if (token) headers["X-CSRF-Token"] = token;

    const response = await fetch(url, {
      method: method.toUpperCase(),
      headers,
      credentials: "same-origin"
    });

    if (response.ok) {
      // Try to process Turbo Stream or HTML
      const contentType = response.headers.get("Content-Type");
      const body = await response.text();
      if (contentType && contentType.includes("turbo-stream")) {
        Turbo.renderStreamMessage(body);
      } else {
        Turbo.visit(url);
      }
      // Close the modal
      if (this.hasModalTarget) {
        const modal = bootstrap.Modal.getInstance(this.modalTarget) || new bootstrap.Modal(this.modalTarget);
        modal.hide();
      }
    }
  }
}
