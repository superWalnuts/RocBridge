var webpack = require('webpack');

var path = require('path');
var fs= require('fs')


let existsMainJS = fs.existsSync("./main.js");
let existsMainTS = fs.existsSync("./main.ts");

if (!existsMainJS && !existsMainTS) {
    console.log("\n\033[00;31mERROR:main.js and main.ts are not exist in the root directory" + '\033[0m');
    process.exit(0);
}

let mainPath = existsMainJS?'./main.js':'./main.ts'


module.exports = {
    entry: mainPath,
    output: {
        filename: './build/bundle.js'
    },

    resolve: {
        // Add '.ts' and '.tsx' as resolvable extensions.
        extensions: ["*", ".webpack.js", ".web.js", ".ts", ".tsx", ".js", ".jsx"]
    },
    module: {
        rules: [
            {
                test: /\.js$|\.tsx?$/,
                enforce: 'pre',
                use:{
                    loader: 'babel-loader',
                    options:{
                        configFile: __dirname + '/babel.config.js'
                    }
                },
            }
        ]
    },
    plugins : [
        new webpack.optimize.UglifyJsPlugin({
            sourceMap : true,
            compress: {
              warnings: false,
              drop_console: true,
            }
        })
    ]
}