module.exports =
  name:   'loginForm'
  model:  'credentials'
  submit: 'login'
  fields:
    username:
      label: 'Username'
      type: 'text'
      attrs:
        required: ''
        autofocus: ''
      errors:
        required:
          msg: 'username is required'
    password:
      label: 'Password'
      type: 'password'
      attrs:
        required: ''
      errors:
        required:
          msg: 'password is required'