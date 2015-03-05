module.exports =
  name:   'registerForm'
  model:  'details'
  submit: 'register'
  fields: [
    {
      name:   'username'
      label:  'Username:'
      type:   'text'
      attrs:  { required: '', minlength: '3' }
      errors: [
        {
          condition: 'required'
          msg:       'username is required'
        }
        {
          condition: 'minlength'
          msg:       'username must be at least 3 characters long'
        }
      ]
    }
    {
      name:   'password'
      label:  'Password:'
      type:   'password'
      attrs:  { required: '', minlength: '6' }
      errors: [
        {
          condition: 'required'
          msg:       'password is required'
        }
        {
          condition: 'minlength'
          msg:       'password must be at least 6 characters long'
        }
      ]
    }
    {
      name:   'confirmPassword'
      label:  'Confirm password:'
      type:   'password'
      attrs:  { required: '', match: 'password' }
      errors: [
        {
          condition: 'required'
          msg:       'password confirmation is required'
        }
        {
          condition: 'match'
          msg:       'passwords don\'t match'
        }
      ]
    }
    {
      name:   'email'
      label:  'E-mail address:'
      type:   'email'
      attrs:  { required: '' }
      errors: [
        {
          condition: 'required'
          msg:       'e-mail address is required'
        }
        {
          condition: 'email'
          msg:       'not a valid e-mail address'
        }
      ]
    }
  ]