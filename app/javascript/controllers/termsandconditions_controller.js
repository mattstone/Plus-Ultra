import { Controller } from "@hotwired/stimulus"
import BaseController from "controllers/base_controller"

export default class extends Controller {
  static targets = [ "checkbox", "submitButton" ]

  
  connect() {
  }
  
  checkbox_ticked() {
    if (this.checkboxTarget.checked == true) {
      this.submitButtonTarget.disabled = false
    } else {
      this.submitButtonTarget.disabled = true
    }
  }

}
