module.exports =
  name:   'registerForm'
  model:  'details'
  submit: 'register'
  fields:
    username:
      label: 'Username'
      type: 'text'
      attrs:
        required: ''
        minlength: '3'
      errors:
        required:
          msg: 'username is required'
        minlength:
          msg: 'username must be at least 3 characters long'

    password:
      label: 'Password'
      type: 'password'
      attrs:
        required: ''
        minlength: '6'
      errors:
        required:
          msg: 'password is required'
        minlength:
          msg:  'password must be at least 6 characters long'

    confirmPassword:
      label: 'Confirm password'
      type: 'password'
      attrs:
        required: ''
        match: 'password'
      errors:
        required:
          msg: 'password confirmation is required'
        match:
          msg: 'passwords don\'t match'
    email:
      label: 'E-mail address'
      type: 'email'
      attrs:
        required: ''
      errors:
        required:
          msg: 'e-mail address is required'
        email:
          msg: 'not a valid e-mail address'