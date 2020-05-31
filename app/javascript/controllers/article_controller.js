import { Controller } from "stimulus"
import Rails from "@rails/ujs"

export default class extends Controller {

  submit(evt){
    evt.preventDefault()
    let data = JSON.stringify({
      article: {
        subject: $("#subject-editor").val()
      }
    })
    let articleId = contents.dataset.articleid
    Rails.ajax({
      url: `/article/${articleId}`,
      type: 'Patch', 
      dataType: 'json',
      beforeSend: (xhr, options) => {
        options.data = data
        xhr.setRequestHeader('Content-Type', 'application/json')
        return true
      },
      success: resp => {
        
      }, 
      error: err => {
        console.log(err);
      } 
      
    })

    $(".card-header h3").toggle()
    $(".card-header a.edit").toggle()
    $(".card-header a.submit").toggle()
    $(".card-header a.cancel").toggle()
    $("#subject-editor").toggle()
    
  }

}