import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "communication_type", "email_fields" ]

  connect() {
  }

  change_communication_type() {
    if (this.communication_typeTarget.value == "email" || this.communication_typeTarget.value == "bulk_email") {
      this.email_fieldsTarget.classList.remove("d-none")
    }
    
    if (this.communication_typeTarget.value == "sms") {
      this.email_fieldsTarget.classList.add("d-none")
    }

    if (this.communication_typeTarget.value == "inbound_telephone") {
      this.email_fieldsTarget.classList.add("d-none")
    }

    if (this.communication_typeTarget.value == "outbound_telephone") {
      this.email_fieldsTarget.classList.add("d-none")
    }
    
  }
  
  change_layout() {
    
  }
  
}
