import { Controller } from "@hotwired/stimulus"
import FullCalendar from "fullcalendar"
import chroma from "chroma-js"

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

      datesSet: async (info) => {
        await fetch("/events/get_events.json", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
          },
          body: JSON.stringify({ "start_time": info.startStr, "end_time": info.endStr })
        }).then((response) => response.json())
          .then((data) => {
            info.view.calendar.removeAllEvents()

            // TODO: do this directly with the JSON, i just need to find an up to date color library
            data = data.map(element => {
              let background_color = element.team == null ? "#3788d8" : element.team.color
              info.view.calendar.addEvent({
                id: element.id,
                title: element.name,
                allDay: element.all_day,
                start: new Date(element.start_time),
                end: new Date(element.end_time),
                url: element.url,
                backgroundColor: background_color,
                textColor: chroma(background_color).luminance() > 0.5 ? "#6d6753" : "#fffdf6",
                extendedProps: {
                  icon: `fa-${element.team == null ? "star" : element.team.team_type.icon}`
                }
              })
            }
          )
        })
      }
    })

    calendar.render()
  }
}
