import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["form", "objectId", "url"] 
  
  edit(evt){
    evt.preventDefault()
    $("#drag-area").hide()
    $("#"+this.formTarget.value).show()
    $("#back").show()
  }

  drag(evt){
    console.log(evt.target.tagName)
    if(evt.target.tagName === "A"){
      evt.preventDefault()
    }
    $("#back").hide()
    $(".edit_content").hide()
    $("#drag-area").show()
  }
  
  toggleList(evt){
    evt.preventDefault()
    $("#" + this.objectIdTarget.value).toggle()
  }
  
  movePlace(evt){
    evt.preventDefault()
    Rails.ajax({
      url: this.urlTarget.value,
      type: 'POST', 
      dataType: 'json',
      beforeSend: (xhr, options) => {
        options.data = JSON.stringify({id: evt.target.dataset.id})
        xhr.setRequestHeader('Content-Type', 'application/json')
        return true
      },
      success: resp => {
        window.location.replace("/channel");
      }, 
      error: err => {
        console.log(err);
      } 
    })
  }


}