import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["form", "objectId"] 
  
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
  
  toggleOrgList(evt){
    evt.preventDefault()
    $("#" + this.objectIdTarget.value).toggle()
  }
  
  organization(evt){
    evt.preventDefault()
    let organizationId = evt.target.dataset.id
    let data = JSON.stringify({id: organizationId})
    Rails.ajax({
      url: `/switch_organization`,
      type: 'POST', 
      dataType: 'json',
      beforeSend: (xhr, options) => {
        options.data = data
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