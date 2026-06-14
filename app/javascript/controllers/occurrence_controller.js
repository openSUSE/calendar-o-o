import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "destroy", "time" ]

  connect() {
    this.toggleRequired()
  }

  toggleRequired() {
    this.timeTarget.required = !this.destroyTarget.checked
  }
}
