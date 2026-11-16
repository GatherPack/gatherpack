import { Controller } from "@hotwired/stimulus"

// Builds the list of dates[] hidden inputs on the event duplication form.
// Attach to the form card with:
//   data-controller="duplicate-dates"
// Targets: input (type=date), list, empty (placeholder text), submit.
export default class extends Controller {
  static targets = ["input", "list", "empty", "submit"]

  add(event) {
    event.preventDefault()
    const value = this.inputTarget.value
    // Date inputs always yield YYYY-MM-DD; the check also guards the markup below.
    if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) return
    if (this.listTarget.querySelector(`input[name="dates[]"][value="${value}"]`)) return

    const item = document.createElement("div")
    item.className = "badge bg-primary d-inline-flex align-items-center gap-2 me-2 mb-2 fs-6"
    item.innerHTML = `
      <input type="hidden" name="dates[]" value="${value}">
      <span>${value}</span>
      <button type="button" class="btn-close btn-close-white" aria-label="Remove ${value}"
              data-action="duplicate-dates#remove"></button>`
    this.listTarget.appendChild(item)
    this.refresh()
  }

  remove(event) {
    event.target.closest("div").remove()
    this.refresh()
  }

  refresh() {
    const count = this.listTarget.querySelectorAll('input[name="dates[]"]').length
    this.submitTarget.disabled = count === 0
    this.emptyTarget.classList.toggle("d-none", count > 0)
  }
}
