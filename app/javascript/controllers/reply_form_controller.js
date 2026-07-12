import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  toggle(event) {
    const replyId = event.params.id
    const form = this.element.querySelector(`[data-reply-form-id="${replyId}"]`)
    if (form) {
      form.style.display = form.style.display === "none" ? "block" : "none"
    }
  }
}
