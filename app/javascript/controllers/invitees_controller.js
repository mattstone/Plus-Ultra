import { Controller } from "@hotwired/stimulus"
import BaseController from "controllers/base_controller"

export default class extends Controller {
  static targets = [ "query", "searchUrl", "addUrl", "removeUrl", "inviteesSelect", "invitees", "inviteForm" ]
  
  connect() {
  }
  
  options_for_post() {
    const base_controller = new BaseController();
    return base_controller.options_for_post()
  }

  invitees_changed() {
    this.inviteFormTarget.requestSubmit()
  }
  
  add_invitee() {
    this.inviteesTarget.innerHTML = this.inviteesTarget.innerHTML.replace(/[\n\r]/g, '')
    
    if (this.inviteesTarget.innerHTML === "") {
      this.inviteesTarget.innerHTML = this.inviteesSelectTarget.value
    } else {
      this.inviteesTarget.innerHTML += ", " + this.inviteesSelectTarget.value
    }
    
    var select = document.getElementById('select_test')
    if (select) { select.size=1; }
  }
  
  remove_invitee() {
  }
}
