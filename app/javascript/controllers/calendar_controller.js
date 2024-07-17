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
        right: "dayGridMonth,timeGridWeek,timeGridDay,listMonth"
      },

      events: this.eventsValue.map(element => {
        return {
          id: element.id,
          title: element.name,
          start: new Date(element.start_time),
          end: element.end_time === null ? null : new Date(element.end_time),
          url: this.urlPathValue + "/" + element.id
        }
      })
    })

    calendar.render()
  }
}
