import { Controller } from "stimulus"
import Sortable from "sortablejs"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = []

  connect() {
    this.sortable = Sortable.create(this.element, {
      onUpdate: this.moveLink.bind(this),
      group: 'shared',
      animation: 150,
      onRemove: this.removeLink.bind(this)
    })
  }

  moveLink(e) {
    let ids = ($(e.target).children('.saved_link').toArray().map(obj => obj.dataset.id)) //取得group下的id更新位置，target是sortable的方法
    let data = JSON.stringify({ saved_link_ids: ids }) //轉換為JSON形式
    Rails.ajax({
      url: 'saved_link/move',
      type: 'POST',
      dataType: 'json',
      //打AJAX的方法
      beforeSend: (xhr, options) => {
        options.data = data
        xhr.setRequestHeader('Content-Type', 'application/json')
        return true
      }
    })
  }

  removeLink(e) {
    let fromLinkIds = $(e.target).children('.saved_link').toArray().map(obj => obj.dataset.id)
    let toLinkIds = $(e.to).children('.saved_link').toArray().map(obj => obj.dataset.id)
    let toGroupId = $(e.to).toArray().map(obj => obj.dataset.group)
    let data = JSON.stringify({
      from_link_ids: fromLinkIds,
      to_link_ids: toLinkIds,
      to_group_id: toGroupId,
    })
    Rails.ajax({
      url: 'saved_link/move_group',
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