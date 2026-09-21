import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="live-search"
//
// Makes a search form submit itself as you interact with it, so there is no
// "Search" button to click. The form must sit OUTSIDE the turbo-frame it
// targets: Turbo replaces only the frame's contents, so an input that lives
// outside the frame is never re-rendered and keeps focus and cursor position
// while the results swap underneath it.
//
// The flip side of that arrangement is that anything in the toolbar which
// reflects the current search — the Clear button, the count badge on the
// Filters toggle — would go stale, because the server never re-renders it.
// refresh() keeps those in sync on the client instead.
//
// URL syncing is handled by Turbo via data-turbo-action="replace" on the
// form, not by this controller.
export default class extends Controller {
  static targets = ["clear", "count", "panel"]
  static values = { delay: { type: Number, default: 300 } }

  connect() {
    this.refresh()
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  // Both handlers are bound on the form so they catch every field by bubbling,
  // including ones we do not render ourselves (comboboxes). Each ignores the
  // fields the other owns - a select fires input AND change, which would
  // otherwise submit twice.

  // Free text: wait for a pause in typing so we send one request per word
  // rather than one per keystroke.
  input(event) {
    if (!this.#textual(event.target)) return

    this.refresh()
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.submit(), this.delayValue)
  }

  // Selects, checkboxes, date pickers: a deliberate choice, nothing to wait for.
  change(event) {
    if (this.#textual(event.target)) return

    this.refresh()
    clearTimeout(this.timeout)
    this.submit()
  }

  submit() {
    // requestSubmit() fires a submit event (form.submit() does not), which is
    // what lets Turbo intercept it and navigate the frame instead of doing a
    // full page load.
    this.element.requestSubmit()
  }

  clear(event) {
    event.preventDefault()
    clearTimeout(this.timeout)
    // Do NOT use form.reset(): the server rendered every field with the
    // current search already selected, so reset() would restore the search we
    // are trying to clear. Blank each control explicitly instead.
    this.#fields().forEach((field) => {
      if (field.type === "checkbox" || field.type === "radio") {
        field.checked = false
      } else if (field.tagName === "SELECT") {
        // Prefer the blank option; fall back to the first for selects that
        // have none (e.g. Teams' My/All toggle, whose first option is the
        // default the controller assumes anyway).
        const blank = Array.from(field.options).find((o) => o.value === "")
        field.value = blank ? "" : (field.options[0]?.value ?? "")
      } else {
        field.value = ""
      }
    })
    this.refresh()
    this.submit()
  }

  // Drops a single filter. Fired by a chip inside the frame, via
  // search_signal_controller.
  removeFilter(event) {
    const name = event.detail?.field
    if (!name) return

    clearTimeout(this.timeout)
    this.element
      .querySelectorAll(`[name="${name}"]`)
      .forEach((field) => {
        if (field.type === "checkbox" || field.type === "radio") {
          field.checked = false
        } else {
          // Back to the declared default, not necessarily blank.
          field.value = field.dataset.liveSearchDefault ?? ""
        }
      })
    this.refresh()
    this.submit()
  }

  // Keep the toolbar honest about what is currently applied.
  refresh() {
    if (this.hasClearTarget) {
      this.clearTarget.hidden = !this.#anyApplied(this.#fields())
    }
    if (this.hasCountTarget && this.hasPanelTarget) {
      const applied = this.#anyApplied(this.#fields(this.panelTarget), true)
      this.countTarget.textContent = applied
      this.countTarget.hidden = applied === 0
    }
  }

  #textual(el) {
    if (!el) return false
    if (el.tagName === "TEXTAREA") return true
    return el.tagName === "INPUT" &&
      [ "text", "search", "email", "tel", "url", "" ].includes(el.type)
  }

  #fields(root = this.element) {
    return Array.from(root.querySelectorAll("input, select")).filter(
      (field) => !["hidden", "submit", "button"].includes(field.type)
    )
  }

  #anyApplied(fields, count = false) {
    const applied = fields.filter((field) => {
      // With a declared default, anything other than that default counts -
      // including blank, which is Questions' "All" against a default of
      // "Open". Without one, blank just means unset.
      const fallback = field.dataset.liveSearchDefault
      if (fallback !== undefined) return String(field.value) !== fallback

      return field.type === "checkbox" || field.type === "radio"
        ? field.checked
        : field.value !== "" && field.value != null
    })
    return count ? applied.length : applied.length > 0
  }
}
