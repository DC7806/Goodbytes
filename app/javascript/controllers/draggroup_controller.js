import { Controller } from "stimulus"
import Sortable from "sortablejs"
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = []

  connect() {
    this.sortable = Sortable.create(this.element, {
      onUpdate: this.moveGroup.bind(this),
      animation: 250,
    })
  }

  moveGroup(e) {
    let ids = $(e.target).children('.a_group').toArray().map(obj => obj.dataset.groupid)
    let data = JSON.stringify({ group_ids: ids })
    Rails.ajax({
      url: 'link_group/move_group',
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