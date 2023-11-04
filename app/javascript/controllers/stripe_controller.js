import { Controller } from "@hotwired/stimulus"

import { loadStripe } from '@stripe/stripe-js'

export default class extends Controller {

  connect() {
    
    let client_secret = document.getElementById('scs').innerHTML

    setTimeout(async () => {
      const stripe   = await loadStripe('pk_test_7F237gcfmL4Ue68h03fsRMM800gOed7xlg')
      const elements = stripe.elements({ clientSecret: client_secret })
      const paymentElement = elements.create('payment')
      paymentElement.mount('#payment-element')
    }, 1);
  }

}
