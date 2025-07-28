import { Controller } from "@hotwired/stimulus"
import FullCalendar from "fullcalendar"

// Connects to data-controller="calendar"
export default class extends Controller {
  static values = {
    timezone: String,
    defaultView: String,
  }

  connect() {
    const calendarEl = document.getElementById("calendar")
    const calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: this.defaultViewValue || "dayGridMonth",
      editable: false,
      fixedWeekCount: false,
      weekNumbers: true,
      dayMaxEventRows: true,
      timeZone: this.timezoneValue,

      headerToolbar: {
        left: "prev,next " + "today",
        center: "title",
        right: "listMonth,dayGridMonth,timeGridWeek"
      },

      buttonText: {
        today: "Today",
        month: "Month",
        week: "Week",
        day: "Day",
        list: "List"
      },

      eventDidMount: (info) => {
        const query = calendar.view.type === "listMonth" ? ".fc-list-event-title" : ".fc-event-title"

        let span = document.createElement("span")
        span.classList.add("d-inline-block", "badge", "rounded-pill", "me-1", "border")
        span.style.backgroundColor = info.event.backgroundColor
        span.style.borderColor = info.event.borderColor
        let icon = document.createElement("i")
        icon.classList.add("fa-solid", "fa-fw", info.event.extendedProps.icon)
        icon.style.color = info.event.textColor
        span.append(icon)

        info.el.querySelector(query).prepend(span)
      },

      events: async (info, successfulCallback, failureCallback) => {
        await fetch("/calendar/calendar.json", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
          },
          body: JSON.stringify(Object.assign({ "start_time": info.start.toISOString(), "end_time": info.end.toISOString(), "q": this.parse_params(document.getElementsByTagName("turbo-frame")[0])}, this.get_view_settings()))
        }).then((response) => response.json())
          .then((data) => {
            successfulCallback(data)
        })
      }
    })

    calendar.render()

    if (document.querySelectorAll("[id^='calendar-']").length != 0) { 
      this.render_initial_settings(calendar)
    }
  }

  get_view_settings() {
    return {
      birthdays: this.evalute_setting_from_local_storage("calendar-birthdays"),
      events: this.evalute_setting_from_local_storage("calendar-events"),
      notes: this.evalute_setting_from_local_storage("calendar-notes")
    }
  }

  evalute_setting_from_local_storage(setting) {
    setting = localStorage.getItem(setting)
    if (setting === null) { return true }

    return setting === "true"
  }

  render_initial_settings(calendar) {
    const initial_settings = this.get_view_settings()

    document.getElementById("calendar-birthdays").checked = initial_settings.birthdays
    document.getElementById("calendar-events").checked = initial_settings.events
    document.getElementById("calendar-notes").checked = initial_settings.notes

    document.getElementById("calendar-settings-submit").addEventListener("click", () => {
      localStorage.setItem("calendar-birthdays", document.getElementById("calendar-birthdays").checked)
      localStorage.setItem("calendar-events", document.getElementById("calendar-events").checked)
      localStorage.setItem("calendar-notes", document.getElementById("calendar-notes").checked)

      calendar.refetchEvents()
    })
  }

  parse_params(el) {
    if (!el) {
      return {}
    }

    const params = new URLSearchParams(el.src)
    let search_params = {}
    params.forEach((value, key, parent) => {
      let parsed_key = key.match(/\[(.*?)\]/)
      if (parsed_key) {
        search_params[parsed_key[1]] = value
      }
    })
    return search_params
  }
}
