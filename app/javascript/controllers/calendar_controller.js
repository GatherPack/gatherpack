import { Controller } from "@hotwired/stimulus"
import FullCalendar from "fullcalendar"

// Connects to data-controller="calendar"
export default class extends Controller {
  connect() {
    const calendarEl = document.getElementById("calendar")
    const calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: "dayGridMonth",
      editable: false,
      fixedWeekCount: false,
      weekNumbers: true,
      dayMaxEventRows: true,
      timeZone: "UTC",

      headerToolbar: {
        left: "prev,next " + "today",
        center: "title",
        right: "dayGridMonth,timeGridWeek,listMonth"
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
        await fetch("/events/get_events.json", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
          },
          body: JSON.stringify({ "start_time": info.start.toISOString(), "end_time": info.end.toISOString()})
        }).then((response) => response.json())
          .then((data) => {
            console.log(data)
            successfulCallback(data)
        })
      }
    })

    calendar.render()
  }
}
