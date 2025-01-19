import { Controller } from "@hotwired/stimulus"
import FullCalendar from "fullcalendar"
import chroma from "chroma-js"

// Connects to data-controller="calendar"
export default class extends Controller {
  static values = {
    events: Array
  }

 
  connect() {
    const calendarEl = document.getElementById("calendar")
    this.calendar = new FullCalendar.Calendar(calendarEl, {
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
        const query = this.calendar.view.type === "listMonth" ? ".fc-list-event-title" : ".fc-event-title"

        let span = document.createElement("span")
        span.classList.add("d-inline-block", "badge", "rounded-pill", "me-1", "border")
        span.style.backgroundColor = info.event.backgroundColor
        span.style.borderColor = info.event.borderColor
        let icon = document.createElement("i")
        icon.classList.add("fa-solid", "fa-fw", info.event.extendedProps.icon)
        icon.style.color = info.event.textColor
        span.append(icon)

        info.el.querySelector(query).prepend(span)
      }
    })

    this.fetch_events()
    this.calendar.render()
  }

  async fetch_events() {
    let view = this.calendar.getCurrentData().viewApi.calendar.view
    await fetch("/events/get_events.json", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ "start_time": view.activeStart.toISOString(), "end_time": view.activeEnd.toISOString() })
    }).then((response) => response.json())
      .then((data) => {
        console.log(data)
        data = data.map(element => {
          let background_color = element.team == null ? "#3788d8" : element.team.color
          return {
            id: element.id,
            title: element.name,
            start: new Date(element.start_time),
            end: new Date(element.end_time),
            url: "events/" + element.id,
            backgroundColor: background_color,
            textColor: chroma(background_color).luminance() > 0.5 ? "#6d6753" : "#fffdf6",
            extendedProps: {
              icon: `fa-${element.team == null ? "star" : element.team.team_type.icon}`
            }
          }
        }
      )
      return data
    })
  }
}
