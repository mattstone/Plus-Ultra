import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    const form = document.getElementById('confirm_2fa_form')
    
    if (form) {
      
      const code_inputs = form.querySelectorAll('input')
    
      const KEYBOARDS = {
        backspace:   8,
        arrowLeft:  37,
        arrowRight: 39,
      }    
      
      form.addEventListener('input', (e) => {
        this.handleInput(e)
    
        let digit_1 = document.getElementById("digit_1")
        let digit_2 = document.getElementById("digit_2")
        let digit_3 = document.getElementById("digit_3")
        let digit_4 = document.getElementById("digit_4")
        let digit_5 = document.getElementById("digit_5")
        let digit_6 = document.getElementById("digit_6")
    
        // Must exist
        if (!digit_1) { return }
        if (!digit_2) { return }
        if (!digit_3) { return }
        if (!digit_4) { return }
        if (!digit_5) { return }
        if (!digit_6) { return }
    
        // Must have digits
        if (digit_1.value.replace(/\D/g,'') == "") { return }
        if (digit_2.value.replace(/\D/g,'') == "") { return }
        if (digit_3.value.replace(/\D/g,'') == "") { return }
        if (digit_4.value.replace(/\D/g,'') == "") { return }
        if (digit_5.value.replace(/\D/g,'') == "") { return }
        if (digit_6.value.replace(/\D/g,'') == "") { return }

         // If we get here all is good
        //form.requestSubmit() // submit form with hotwire        
        let button = document.getElementById('confirm_2fa_button')
        if (button) { button.click() }
      })
      
      code_inputs[0].addEventListener('paste', this.handlePaste)
      
      code_inputs.forEach(code_input => {
        code_input.addEventListener('focus', e => {
          setTimeout(() => { e.target.select() }, 0)
        })

        code_input.addEventListener('keydown', e => {
          switch(e.keyCode) {
            case KEYBOARDS.backspace:
              this.handleBackspace(e)
              break
            case KEYBOARDS.arrowLeft:
              this.handleArrowLeft(e)
              break
            case KEYBOARDS.arrowRight:
              this.handleArrowRight(e)
              break
            default:  
          }
        })
      })      
    }
  }
  
  handleInput(e) {
     let element = document.getElementById(e.srcElement.id)
     
     if (!element) { return }
     
     element.value = element.value.replace(/\D/g,'') // accept digits only
     if (element.value == "") { return }

      const code_input = e.target
      const nextInput  = code_input.nextElementSibling
      if (nextInput && code_input.value) {
        nextInput.focus()
        if (nextInput.value) { nextInput.select() }
      }
  }
    
  handlePaste(e) {
    e.preventDefault()
    const paste = e.clipboardData.getData('text')
    code_inputs.forEach((input, i) => { code_input.value = paste[i] || '' })
  }
    
  handleBackspace(e) { 
    const code_input = e.target
    if (code_input.value) {
      code_input.value = ''
      return
    }
    
    code_input.previousElementSibling.focus()
  }
    
  handleArrowLeft(e) {
    const previousInput = e.target.previousElementSibling
    if (!previousInput) return
    previousInput.focus()
  }
  
  handleArrowRight(e) {
    const nextInput = e.target.nextElementSibling
    if (!nextInput) return
    nextInput.focus()
  }

}
