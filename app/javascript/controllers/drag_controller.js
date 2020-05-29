import { Controller } from "stimulus"
import Rails from "@rails/ujs"
import Sortable from 'sortablejs';

export default class extends Controller {
  static targets = ["drag_area"] 
  connect(){
    window.sortable = Sortable.create(drag_area,{
      group: "shared",
      animation: 250,
      ghostClass: "blue-background-class",
      onUpdate: function (e) {
        let ids =  $(drag_area).children().toArray().map(obj => obj.dataset.id)
        let data = JSON.stringify({contents_ids: ids})
        let articleId = contents.dataset.articleid
        Rails.ajax({
          url: `/article/${articleId}/sort`,
          type: 'POST', 
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
      },
    })

  }
}
