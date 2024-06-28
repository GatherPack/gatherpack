import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbo-search"
export default class extends Controller {
  search(){
    this.element.requestSubmit()
  }
}
