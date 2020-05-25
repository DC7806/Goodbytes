import { Controller } from "stimulus"
import Rails from "@rails/ujs"
import Sortable from 'sortablejs';

export default class extends Controller {
  static targets = ["editor"] 
  contentsLoad(){
    let articleId = contents.dataset.articleid
    Rails.ajax({
      url: `/article/${articleId}/contents`,
      type: "GET",
      success: resp => {
        // console.log("refresh")
      },
      error: err => {
        console.log(err)
      }
    })
  }
  connect(){
    let contentsLoad = this.contentsLoad
    contentsLoad()
    window.sortable = Sortable.create(editor,{
      group: "shared",
      animation: 250,
      ghostClass: "blue-background-class",
      onUpdate: function (e) {
        let items = e.target.children
        function updatePosition(index){
          let item = items[index]
          let itemId = item.dataset.id
          let data = JSON.stringify({content: {position: index}})
          Rails.ajax({
            url: `/contents/${itemId}`, 
            type: 'PATCH', 
            dataType: 'json',
            beforeSend: (xhr, options) => {
              options.data = data
              xhr.setRequestHeader('Content-Type', 'application/json')
              return true
            },
            success: resp => {
              if(index+1 < items.length){
                updatePosition(index+1)
              }else{
                contentsLoad()
              }
            }, 
            error: err => {
              console.log(err);
            } 
          })
        }
        updatePosition(0)
      },
    })

  }
}
