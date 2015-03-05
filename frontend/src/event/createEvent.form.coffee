module.exports =
  name: 'createEventForm'
  model: 'eventDetails'
  submit: 'createEvent'
  fields: [
    {
      name: 'date'
      label: 'Event date:'
      type: 'date'
    }
    {
      name: 'sanctioned'
      label: 'Sanctioned event'
      type: 'checkbox'
    }
    {
      name: 'location'
      label: 'Location:'
      type: 'select'
      show: 'eventDetails.sanctioned'
      options: 'locations'
      errorNoOptions: 'no locations found'
    }
    {
      name: 'format'
      label: 'Format:'
      type: 'select'
      options: 'formats'
    }
    {
      name: 'playerType'
      type: 'radio-buttons'
      options: 'playerTypes'
    }
    {
      name: 'pairingMethod'
      type: 'radio-buttons'
      options: 'pairingMethods'
    }
    {
      name: 'bracketed'
      label: 'Bracketed'
      type: 'checkbox'
      show: 'supportsBracketing()'
    }
    {
      name: 'name'
      label: 'Event name:'
      type: 'text'
      attrs: {required: '', minlength: '3'}
      errors: [
        {
          condition: 'required'
          msg:       'event name is required'
        }
        {
          condition: 'minlength'
          msg:       'event name must be at least 3 characters long'
        }
      ]
    }
    {
      name: 'description'
      label: 'Description:'
      type: 'text'
    }
  ]