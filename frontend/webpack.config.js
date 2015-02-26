module.exports = {
    entry: ['webpack/hot/dev-server', './src/main.coffee'],
    output: {
        path: 'build',
        filename: 'bundle.js'
    },
    module: {
        loaders: [
            { test: /\.css$/,    loader: "style-loader!css-loader" },
            { test: /\.coffee$/, loader: "coffee-loader"           },
            { test: /\.jade$/,   loader: "jade-loader"             }
        ]
    }
};