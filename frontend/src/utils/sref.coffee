sprintf = require('sprintf-js').sprintf

module.exports = (state, params)->
  sprintf('%s(%s)', state, JSON.stringify(params))
