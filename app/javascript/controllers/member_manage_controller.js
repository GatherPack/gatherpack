import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="member-manage"
export default class extends Controller {
  static targets = ["label"]

  toggle() {
    this.element.classList.toggle("manage-mode")
    this.labelTarget.textContent = this.element.classList.contains("manage-mode") ? "Done Managing" : "Manage Members"
  }
}