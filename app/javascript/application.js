// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import "bootstrap"
import "channels"

import LocalTime from "local-time"
LocalTime.start();

Notification.requestPermission().then(function (result) {});

function timezone() {
  return document.cookie
    .split(";")
    .find((row) => row.trim().startsWith("timezone="))
    ?.split("=")[1];
}

function set_timezone() {
  document.cookie = `timezone=${Intl.DateTimeFormat().resolvedOptions().timeZone}; SameSite=Lax; Secure`;
}

if (timezone() !== Intl.DateTimeFormat().resolvedOptions().timeZone) {
  console.log(timezone());
  set_timezone();
  location.reload();
} else {
  set_timezone();
}
