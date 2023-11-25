import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "communication_type", "email_fields" ]

  connect() {
    // console.log("Hello")
  }

  change_communication_type(e) {
    console.log("change_communication_type")
    if (this.communication_typeTarget.value == "email") {
      this.email_fieldsTarget.classList.remove("d-none")
      
    }
    
    if (this.communication_typeTarget.value == "sms") {
      this.email_fieldsTarget.classList.add("d-none")
      
    }

    if (this.communication_typeTarget.value == "inbound_telephone") {
      
    }

    if (this.communication_typeTarget.value == "outbound_telephone") {
      
    }
    
  }
  
  change_layout() {
    
  }
  
}
