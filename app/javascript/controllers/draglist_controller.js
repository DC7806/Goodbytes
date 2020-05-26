import { Controller } from "stimulus"
import Sortable from "sortablejs"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = []

  connect() {
    this.sortable = Sortable.create(this.element, {
      onUpdate: this.sortList.bind(this),
      group: 'shared',
      animation: 150
    })
  }

  sortList(e) {
    let ids = ($(e.target).children('.saved_link').toArray().map(obj => obj.dataset.id)) //取得group下的id更新位置，target是stimulus提共的方法
    let data = JSON.stringify({ saved_link_ids: ids }) //轉換為JSON形式
    Rails.ajax({
      url: 'saved_link/move',
      type: 'POST',
      dataType: 'json',

      beforeSend: (xhr, options) => {
        options.data = data
        xhr.setRequestHeader('Content-Type', 'application/json')
        return true
      }
    })
  }
}
