import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    
    console.log("Hello World! from verify_2fa_controller")
    
    // const form = document.getElementById('two_fa_authentication_form')
    // 
    // if (form) {
    // 
    //   const code_inputs = form.querySelectorAll('input')
    // 
    //   const KEYBOARDS = {
    //     backspace:   8,
    //     arrowLeft:  37,
    //     arrowRight: 39,
    //   }    
    // 
    //   form.addEventListener('input', (e) => {
    //     this.handleInput(e)
    // 
    //     let digit_1 = document.getElementById("digit_1")
    //     let digit_2 = document.getElementById("digit_2")
    //     let digit_3 = document.getElementById("digit_3")
    //     let digit_4 = document.getElementById("digit_4")
    //     let digit_5 = document.getElementById("digit_5")
    //     let digit_6 = document.getElementById("digit_6")
    // 
    //     // Must exist
    //     if (!digit_1) { return }
    //     if (!digit_2) { return }
    //     if (!digit_3) { return }
    //     if (!digit_4) { return }
    //     if (!digit_5) { return }
    //     if (!digit_6) { return }
    // 
    //     // Must have digits
    //     if (digit_1.value.replace(/\D/g,'') == "") { return }
    //     if (digit_2.value.replace(/\D/g,'') == "") { return }
    //     if (digit_3.value.replace(/\D/g,'') == "") { return }
    //     if (digit_4.value.replace(/\D/g,'') == "") { return }
    //     if (digit_5.value.replace(/\D/g,'') == "") { return }
    //     if (digit_6.value.replace(/\D/g,'') == "") { return }
    // 
    // 
    //   })
    // }
  }
  
  
}
