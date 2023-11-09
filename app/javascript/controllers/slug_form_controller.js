import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "slug" ]

  prefillSlug(event) {
    this.slugTarget.value = event.target.value.toLowerCase().replace(/[^a-z0-9]/g, '_');
  }
}
