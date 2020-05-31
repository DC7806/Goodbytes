import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ["form", "objectId","switcher", "url", "toId"] 
  
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
    let targetObject = $("#" + this.objectIdTarget.value)
    targetObject.fadeToggle("fast")
    this.switcherTarget.focus()
    $(this.switcherTarget).on("focusout", function(){
      // 為了可以點擊menu外就隱藏menu，於是加了onFocusOut
      // 同時也是為了解決同時開兩個menu的問題
      targetObject.fadeOut()
    })
  }
  
  movePlace(evt){
    evt.stopPropagation()
    evt.preventDefault()
    let data = JSON.stringify({id: this.toIdTarget.value})
    Rails.ajax({
      url: this.urlTarget.value,
      type: 'POST', 
      dataType: 'json',
      beforeSend: (xhr, options) => {
        options.data = data
        xhr.setRequestHeader('Content-Type', 'application/json')
        return true
      },
      success: resp => {
        // 其實就是redirect_to，在javascript裡的寫法是這樣
        window.location.replace("/channel");
      }, 
      error: err => {
        console.log(err);
      } 
    })
  }


}