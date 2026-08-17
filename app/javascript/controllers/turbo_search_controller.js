import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbo-search"
export default class extends Controller {
  search(){
    const params = new URLSearchParams(new FormData(this.element))
    const url = `${this.element.getAttribute("action")}?${params}`
    history.pushState({}, "", url)
  }

  clear(){
    this.element.reset()
  }
}
