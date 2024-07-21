import { Controller } from "@hotwired/stimulus"
import FullCalendar from "fullcalendar"
import chroma from "chroma-js";

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
        let icon_background_color = element.team == null ? "#3788d8" : element.team.color
        return {
          id: element.id,
          title: element.name,
          start: new Date(element.start_time),
          end: new Date(element.end_time),
          url: this.urlPathValue + "/" + element.id,
          extendedProps: {
            icon: `fa-${element.team == null ? "star" : element.team.team_type.icon}`,
            iconBackgroundColor: icon_background_color,
            iconColor: chroma(icon_background_color).luminance() > 0.5 ? "#6d6753" : "#fffdf6"
          }
        }
      }),

      eventDidMount: (info) => {
        const query = calendar.view.type === "listMonth" ? ".fc-list-event-title" : ".fc-event-title"

        let span = document.createElement("span")
        span.classList.add("badge", "rounded-pill", "ms-2")
        span.style.backgroundColor = info.event.extendedProps.iconBackgroundColor
        let icon = document.createElement("i")
        icon.classList.add("fa-solid", "fa-fw", info.event.extendedProps.icon)
        icon.style.color = info.event.extendedProps.iconColor
        span.append(icon)

        info.el.querySelector(query).append(span)
      }
    })

    calendar.render()
  }
}
