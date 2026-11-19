import { Controller } from "@hotwired/stimulus"

// Live checkbox toggles on the bulk badge-assignment page. The controller
// wraps both the earned-on date field and the turbo frame of checkboxes, so
// toggles after a search/page swap still dispatch here.
export default class extends Controller {
  static values = { url: String }
  static targets = ["date"]

  toggle(event) {
    const box = event.target
    const row = box.closest("[data-bulk-row]")
    const error = row ? row.querySelector("[data-bulk-error]") : null
    if (error) error.textContent = ""
    box.disabled = true

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        person_id: box.dataset.personId,
        assigned: box.checked,
        earned_on: this.dateTarget.value
      })
    }).then((response) => {
      if (!response.ok) { return response.json().then((data) => { throw data }) }
    }).catch((data) => {
      box.checked = !box.checked
      if (error) error.textContent = (data && data.errors) ? data.errors.join(", ") : "Save failed"
    }).finally(() => {
      box.disabled = false
    })
  }
}
