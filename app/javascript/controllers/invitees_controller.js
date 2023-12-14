import { Controller } from "@hotwired/stimulus"
import BaseController from "controllers/base_controller"

export default class extends Controller {
  static targets = [ "query", "searchUrl", "addUrl", "removeUrl", "inviteesSelect", "invitees", "inviteForm" ]
  
  connect() {
    console.log("I am invitees controller")
  }
  
  options_for_post() {
    const base_controller = new BaseController();
    return base_controller.options_for_post()
  }

  invitees_changed() {
    console.log("invitees_changed")
    console.log(this.inviteFormTarget)
    this.inviteFormTarget.requestSubmit()
  }
  
  // invitees_changed_old() {
  //   let url      = this.searchUrlTarget.innerHTML
  //   let options  = this.options_for_post()
  //   let data     = { query: this.queryTarget.value }
  //   options.body = JSON.stringify(data)
  // 
  //   console.log(options)
  // 
  //   fetch(url, options)
  //     .then(response => response.json())   // if the response is a JSON object
  //     .then(json     => {
  //       console.log(json)
  // 
  //       this.inviteesSelectTarget.innerHTML = null
  // 
  //       for(var e of json) {
  //         this.inviteesSelectTarget.innerHTML += `<option value="${e.email}">${e.email} <${e.first_name} ${e.last_name}></option>`
  //       }
  // 
  //       //this.inviteesSelectTarget.size(20)
  // 
  //       var select = document.getElementById('select_test')
  //       if (select) { select.size=select.options.length; }
  // 
  //     })
  //     .catch(error   => console.log(error)); // Handle the error response object
  // }
  
  add_invitee() {
    console.log("add_invitee")
    console.log(this.inviteesSelectTarget.value)
    
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
    console.log("remove_invitee")
    
  }
}
