module.exports =
  name:   'loginForm'
  model:  'credentials'
  submit: 'login'
  fields: [
    {
      name:   'username'
      label:  'Username:'
      type:   'text'
      attrs:  { required: '', autofocus: '' }
      errors: [
        {
          condition: 'required'
          msg:       'username is required'
        }
      ]
    }
    {
      name:   'password'
      label:  'Password:'
      type:   'password'
      attrs:  { required: '' }
      errors: [
        {
          condition: 'required'
          msg:       'password is required'
        }
      ]
    }
  ]
