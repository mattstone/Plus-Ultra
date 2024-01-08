import { Controller } from "@hotwired/stimulus"
import BaseController from "controllers/base_controller"

export default class extends Controller {
  static targets = [ "checkbox", "submitButton" ]

  
  connect() {
    console.log("I am termsandconditions_controller")
  }
  
  checkbox_ticked() {
    console.log('checkbox_ticked')
    
    console.log(this.checkboxTarget.checked)
    
    if (this.checkboxTarget.checked == true) {
      this.submitButtonTarget.disabled = false
    } else {
      this.submitButtonTarget.disabled = true
    }
  }

}
