import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    defaultColor: {type: String, default: "#000000"},
    color: {type: String, default: "#000000"},
  }

  static classes = ["active", "inactive", "linkError"]
  static targets = ["backgroundColor", "textColor", "underlineColorPicker", "underlineColorPickerModal", "fontSizeControls", "fontSizeInput"]

  initialize() {
    this.allowSync = true
  }

  changeColor(e) {
    this.colorValue = e.detail
    if(this.backgroundColorTarget.contains(e.target)) {
      this.trixEditor.activateAttribute("backgroundColor", e.detail)
    } else if(this.textColorTarget.contains(e.target)) {
      this.trixEditor.activateAttribute("foregroundColor", e.detail)
    } else {
      this.trixEditor.activateAttribute("underlineColor", e.detail)
    }
  }

  connect() {
    import("@rails/actiontext").catch(err => console.log(err))
    import("trix").catch(err => console.log(err))
    
    this.setupTrix()
    // this.element.classList.add(...this.inactiveClasses)
    // this.element.classList.remove(...this.activeClasses)
    
    // console.log("foo")
    // console.log(this.trix)
    
    this.trix.classList.add(...this.inactiveClasses)
    this.trix.classList.remove(...this.activeClasses)
  }

  markSelection() {
    this.trixEditor.activateAttribute("frozen")
    this.fontSizeInputTarget.focus()
    this.trix.blur()
  }

  setupTrix() {
    Trix.config.textAttributes.foregroundColor = {
      styleProperty: "color",
      inheritable: 1
    }

    Trix.config.textAttributes.backgroundColor = {
      styleProperty: "background-color",
      inheritable: 1
    }

    Trix.config.textAttributes.underline = {
      style: { textDecoration: "underline" },
      parser: function(element) {
        return element.style.textDecoration === "underline"
      },
      inheritable: 1
    }

    Trix.config.textAttributes.underlineColor = {
      styleProperty: "text-decoration-color",
      inheritable: 1
    }

    Trix.config.textAttributes.fontSize = {
      styleProperty: "font-size",
      inheritable: 1
    }

    // this.trix = this.element.querySelector("trix-editor")
    this.trix = document.querySelector("trix-editor")
    //document.querySelector(".trix-button-group--text-tools")
    
    
    
    // initialize underline attribute
      Trix.config.textAttributes.underline = {
        tagName: "u",
        style: { textDecoration: "underline" },
        inheritable: true,
        parser: function (element) {
          var style = window.getComputedStyle(element);
          return style.textDecoration === "underline";
        },
      };
    
      // create underline button
      let underlineEl = document.createElement("button");
      underlineEl.setAttribute("type", "button");
      underlineEl.setAttribute("data-trix-attribute", "underline");
      underlineEl.setAttribute("data-trix-key", "u");
      underlineEl.setAttribute("tabindex", -1);
      underlineEl.setAttribute("title", "underline");
      underlineEl.classList.add("trix-button", "trix-button--icon-underline");
      underlineEl.innerHTML = "U";
    
      // add button to toolbar - inside the text tools group
      document.querySelector(".trix-button-group--text-tools").appendChild(underlineEl);    
  }

  changeSelectionFontSize({ detail: font }) {
    this.trixEditor.activateAttribute("fontSize", font.px)
    this.trixEditor.deactivateAttribute("frozen")
  }

  toggleUnderline() {
    if(this.trixEditor.attributeIsActive("underline")) {
      this.trixEditor.deactivateAttribute("underline")
    } else {
      this.trixEditor.activateAttribute("underline")
    }

    this.trix.focus()
  }

  sync() {
    if(this.trixEditor.attributeIsActive("underline")) {
      this.underlineColorPickerTarget.disabled = false
      this.underlineColorPickerTarget.classList.remove("text-gray-300")
    } else {
      this.underlineColorPickerTarget.disabled = true
      this.underlineColorPickerTarget.classList.add("text-gray-300")
    }

    if (this.pieceAtCursor.attributes.has("fontSize")) {
      this.dispatch("font-size:sync", {
        target: this.fontSizeControlsTarget,
        detail: this.pieceAtCursor.getAttribute("fontSize")
      })
    }
  }

  toggleUnderlineColorPicker() {
    const piece = this.pieceAtCursor

    if (piece.attributes.has("underline")) {
      const indexOfPiece = this.trixEditorDocument.toString().indexOf(piece.toString())
      const textRange = [indexOfPiece, indexOfPiece + piece.length]
      this.trixEditor.setSelectedRange(textRange)
    }

    this.underlineColorPickerModalTarget.classList.toggle("hidden")
  }

  get pieceAtCursor() {
    return this.trixEditorDocument.getPieceAtPosition(this.trixEditor.getPosition())
  }

  get trixEditor() {
    return this.trix.editor
  }

  get trixEditorDocument() {
    return this.trix.editor.getDocument()
  }

  get fontSizeDropdownLabelContainer() {
    return this.element.querySelector('[data-custom-dropdown-target="placeholderText"]')
  }

  get currentState() {
    return {
      boldValue: this.boldValue,
      italicValue: this.italicValue,
      alignmentValue: this.alignmentInputTarget.value,
      color: this.colorValue,
      sizeValue: this.sizeValue,
      trix: this.trix
    }
  }
}
