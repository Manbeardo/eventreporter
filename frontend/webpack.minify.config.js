var webpack = require('webpack');
var config = require('./webpack.config.js');

config.output = {path: 'build', filename: 'bundle.min.js'};
config.plugins.push(new webpack.optimize.UglifyJsPlugin({minimize: true}));

module.exports = config;