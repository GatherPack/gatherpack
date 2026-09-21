import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-signal"
//
// Used by the chips and the empty state, which render inside the turbo-frame
// and so cannot reach the search form directly. Rather than navigate - which
// races whatever frame request is already in flight - they dispatch a window
// event that live_search_controller acts on.
export default class extends Controller {
  static values = { field: String }

  clear(event) {
    event.preventDefault()
    this.dispatch("clear", { target: window, prefix: "search" })
  }

  remove(event) {
    event.preventDefault()
    this.dispatch("remove", { target: window, prefix: "search", detail: { field: this.fieldValue } })
  }
}
