import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "iframe", "campaign", "url", "height", "heightInputRow" ]

  connect() {
  }
  
  adjust_iframe_height() {
    this.iframeTarget.style.height = `${this.heightTarget.value}px`
  }

  preview() {
    this.iframeTarget.srcdoc = "Generating preview.."
    
    let url     = this.urlTarget.innerHTML.replace("ID", String(this.campaignTarget.value))
    let options = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
      }
    }
    
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
}