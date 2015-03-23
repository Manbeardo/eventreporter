module.exports =
  fields:
    date:
      label: 'Start Date'
      type: 'date'

    sanctioned:
      type: 'radio-bool-buttons'
      options:
        false:
          name: "Unsanctioned"
        true:
          name: "Sanctioned"

    sanctioningBody:
      type: 'select-dynamic'
      label: 'Sanctioning Body'
      show: 'eventDetails.sanctioned'
      options: 'sanctioningBodies'
      errorNoOptions: 'no sanctioning bodies found'

    location:
      label: 'Location'
      type: 'select-dynamic'
      show: 'eventDetails.sanctioned'
      options: 'locations'
      errorNoOptions: 'no locations found'

    format:
      label: 'Format'
      type: 'select'
      options: require '../config/formats.coffee'

    playerType:
      type: 'radio-buttons'
      default: 'solo'
      attrs:
        required: ''
      options:
        solo:
          name: 'Individual'
        pair:
          name: 'Two-Headed Giant'
          disabled: '!eventDetails.format.giant'
        trio:
          name: 'Trios'
          disabled: '!eventDetails.format.trios'

    pairingMethod:
      type: 'radio-buttons'
      attrs:
        required: ''
      options:
        swiss:
          name: 'Swiss'
        single:
          name: 'Single Elimination'
        double:
          name: 'Double Elimination'

    bracketed:
      type: 'radio-bool-buttons'
      show: 'supportsBracketing()'
      options:
        false:
          name: "Unbracketed"
        true:
          name: "Bracketed"

    rounds:
      label: 'Rounds'
      type: 'number'
      show: 'eventDetails.pairingMethod.name == "Swiss"'
      attrs:
        min: '1'
        max: '50'
      errors:
        min:
          msg: 'event must have at least one round'
        max:
          msg: 'event must have no more than fifty rounds'

    name:
      label: 'Full name'
      type: 'text'
      attrs:
        required: ''
        minlength: '3'
      errors:
        required:
          msg:       'event name is required'
        minlength:
          msg:       'event name must be at least 3 characters long'

    shortName:
      label: 'Short name'
      type: 'text'
      attrs:
        required: ''
        minlength: '3'
      errors:
        required:
          msg: 'short name is required'
        minlength:
          msg: 'short name must be at least 3 characters long'