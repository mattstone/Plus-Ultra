import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  options_for_post() {
    return {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
      }
    }
  }
  
}
