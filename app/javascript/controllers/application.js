import { Application } from "@hotwired/stimulus"
import { Autocomplete } from "stimulus-autocomplete"
import { Datepicker } from 'stimulus-datepicker'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

application.register('autocomplete', Autocomplete)
application.register('datepicker', Datepicker)

export { application }
