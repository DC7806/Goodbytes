import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["form", "loader"] 

  preSubmit(evt){
    let form = this.formTarget
    $(this.loaderTarget).toggle()
  }

}