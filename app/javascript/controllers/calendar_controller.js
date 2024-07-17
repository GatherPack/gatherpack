import { Controller } from "@hotwired/stimulus"
import FullCalendar from "fullcalendar"

// Connects to data-controller="calendar"
export default class extends Controller {
  static values = {
    urlPath: String,
    events: Array
  }

  connect() {
    const calendarEl = document.getElementById("calendar")
    const calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: "dayGridMonth",
      editable: false,
      fixedWeekCount: false,
      navLinks: true,
      weekNumbers: true,
      dayMaxEventRows: true,

      headerToolbar: {
        left: "prev,next today",
        center: "title",
        right: "dayGridMonth,timeGridWeek,listMonth"
      },

      events: this.eventsValue.map(element => {
        return {
          id: element.id,
          title: element.name,
          start: new Date(element.start_time),
          end: new Date(element.end_time),
          url: this.urlPathValue + "/" + element.id,
          // backgroundColor: element.team == null ? "" : element.team.color,
          extendedProps: {
            icon: `fa-${element.team == null ? "star" : element.team.team_type.icon}`
          }
        }
      }),

      eventDidMount: (info) => {
        const query = calendar.view.type === "listMonth" ? ".fc-list-event-title" : ".fc-event-title"

        let span = document.createElement("span")
        span.classList.add("badge", "rounded-pill") 
        let icon = document.createElement("i")
        icon.classList.add("fa-solid", info.event.extendedProps.icon)
        span.append(icon)

        info.el.querySelector(query).append(span)
      }
    })

    calendar.render()
  }
}
