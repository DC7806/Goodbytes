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

}