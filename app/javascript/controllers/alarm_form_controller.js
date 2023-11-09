import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "type", "email" ]

  emailTargetConnected(element) {
    this.toggleEmail();
  }

  toggleEmail() {
    if (this.typeTarget.value === 'AlarmEmail')
      this.show(this.emailTarget)
    else
      this.hide(this.emailTarget)
  }

  show(target) {
    target.classList.remove("d-none")
  }

  hide(target) {
    target.classList.add("d-none")
  }
}
