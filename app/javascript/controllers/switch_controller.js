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
    let object = $("#" + this.objectIdTarget.value)
    object.toggle()
    $(evt.target).on("focusout", function(){
      // 為了可以點擊menu外就隱藏menu，於是加了onFocusOut
      // 同時也是為了解決同時開兩個menu的問題
      // 但同時又發現會有來不及點menu內選項就被隱藏的問題
      // 所以設了timeout，隱藏會稍微慢一點，但要很用心去體會才會發現啦
      setTimeout( () => { object.hide() }, 200)
    })
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
        // 其實就是redirect_to，在javascript裡的寫法是這樣
        window.location.replace("/channel");
      }, 
      error: err => {
        console.log(err);
      } 
    })
  }


}