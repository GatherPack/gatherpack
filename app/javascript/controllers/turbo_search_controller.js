import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbo-search"
export default class extends Controller {

  search(){
    this.closeModalIfInModal()
    this.element.pushState({}, "");
  }

  clear(){
    this.element.reset()
    this.closeModalIfInModal()
  }

  closeModalIfInModal() {
    // Traverse up to find the closest parent with class 'modal'
    let modal = this.element.closest('.modal');
    console.log('are we doing the thing?')
    if (modal) {
      // Bootstrap 5 modal close
      console.log("Closing modal:", modal);
      let modalInstance = bootstrap.Modal.getInstance(modal);
      if (modalInstance) {
        modalInstance.hide();
      } else {
        console.log("Modal instance not found.");
        // If not already initialized, initialize and hide
        modalInstance = new bootstrap.Modal(modal);
        modalInstance.hide();
      }
    }
  }
}
