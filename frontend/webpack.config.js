module.exports = {
    entry: ['webpack/hot/dev-server', './src/main.coffee'],
    output: {
        path: 'build',
        filename: 'bundle.js'
    },
    module: {
        loaders: [
            { test: /\.coffee$/, loader: "coffee-loader" }
        ]
    }
};