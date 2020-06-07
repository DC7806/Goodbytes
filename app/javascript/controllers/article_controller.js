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

    $(".top-bar a.title").toggle()
    $(".top-bar a.edit").toggle()
    $(".top-bar a.submit").toggle()
    $(".top-bar a.cancel").toggle()
    $("#subject-editor").toggle()
    
  }

  mobile(evt){
    evt.preventDefault()
    $('#article-part').width(300)
    // 總寬340
  }

  desktop(evt){
    evt.preventDefault()
    $('#article-part').width(560)
    // 總寬600
  }

}