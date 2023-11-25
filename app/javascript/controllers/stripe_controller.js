import { Controller } from "@hotwired/stimulus"

import { loadStripe } from '@stripe/stripe-js'

export default class extends Controller {

  connect() {
    
    let client_secret = document.getElementById('scs')
    if (client_secret) { 
      let client_secret = document.getElementById('scs').innerHTML
      const messages    = document.getElementById('error-messages')
      messages.classList.add("d-none")

      setTimeout(async () => {
        // const stripe   = await loadStripe('pk_test_7F237gcfmL4Ue68h03fsRMM800gOed7xlg')
        const stripe   = await loadStripe(document.getElementById('spk').innerHTML)
        const elements = stripe.elements({ clientSecret: client_secret })
        const paymentElement = elements.create('payment')
        paymentElement.mount('#payment-element')
        
        const form = document.getElementById('payment-form')
        form.addEventListener('submit', async (e) => {
          e.preventDefault()
          
          const error = await stripe.confirmPayment({
            elements,
            confirmParams: {
              return_url: document.getElementById('return-url').innerHTML
            }
          })
          
          if (error) {
            messages.classList.remove("d-none")
            messages.innerText = error.message
          }
        })
      }, 1);
     }
    
    let poll_button   = document.getElementById('transaction_response_poll')
    if (poll_button)   { 
      
      function poll() {
        let transaction_status = document.getElementById('transaction_status')
        if (transaction_status) {
          if (transaction_status.innerHTML.trim() == "Pending") {
            let poll_button = document.getElementById('transaction_response_poll')
            if (poll_button) { 
              poll_button.click() 
              setTimeout(poll, 1000)
            }
          }
        }
      }
      
      setTimeout(poll, 1000)
    }    
  }  
}
