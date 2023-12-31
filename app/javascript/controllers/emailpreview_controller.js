import { Controller } from "@hotwired/stimulus"
import BaseController from "controllers/base_controller"

export default class extends Controller {
  static targets = [ "iframe", "communication", "url", "height", "heightInputRow", "emailPreview", "emailContent", "layout", "subscribers", "mailing_list", "subscribers_count_url" ]

  connect() {
    this.subscribers()
    this.bulk_preview()
  }
  
  adjust_iframe_height() {
    this.iframeTarget.style.height = `${this.heightTarget.value}px`
  }

  options_for_post() {
    const base_controller = new BaseController();
    return base_controller.options_for_post()
  }

  bulk_preview() {
    this.iframeTarget.srcdoc = "Generating preview.."
    
    let url     = this.urlTarget.innerHTML.replace("ID", String(this.communicationTarget.value))
    let options = this.options_for_post()
    
    fetch(url, options)
      .then(response => response.json())   // if the response is a JSON object
      .then(json     => {
        this.iframeTarget.srcdoc       = json.html
        this.heightTarget.value        = 1000
        this.iframeTarget.style.height = `${this.heightTarget.value}px`
        this.heightInputRowTarget.classList.remove("d-none")
      })
      .catch(error   => console.log(error)); // Handle the error response object
  }
  
  single_email_preview() {
    let data = {
       layout:  this.layoutTarget.value,
       preview: this.emailPreviewTarget.value,
       content: this.emailContentTarget.value
    }

    // Add new content to body
    let options  = this.options_for_post()
    options.body = JSON.stringify(data)
    
    // Build url
    let url = this.urlTarget.innerHTML.replace("ID/", "") + "_new"

    fetch(url, options)
      .then(response => response.json())   // if the response is a JSON object
      .then(json     => {
        this.iframeTarget.srcdoc       = json.html
        this.heightTarget.value        = 1000
        this.iframeTarget.style.height = `${this.heightTarget.value}px`
        this.heightInputRowTarget.classList.remove("d-none")
      })
      .catch(error   => console.log(error)); // Handle the error response object
  }
  
  subscribers() {
    
    let url     = this.subscribers_count_urlTarget.innerHTML.replace("ID", this.mailing_listTarget.value) 
    let options = this.options_for_post()

    fetch(url, options)
      .then(response => response.json())   // if the response is a JSON object
      .then(json     => {
        this.subscribersTarget.innerHTML = json.subscribers
      })
      .catch(error   => console.log(error)); // Handle the error response object

  }
}