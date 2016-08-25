

var webpack = require("webpack");
var path = require("path");

module.exports = {
	entry: {
		'brianledger_public': "./brianledger_public/__main__.coffee",
		//'softarc_public': "./softarc_public/client/__main__.coffee",
		//'client_public': "./client_public/__main__.coffee"
	},
	output: {
		publicPath: "/",
		path: ".",
		filename: "[name].js",
	},
	module: {
		loaders: [
			{ test: /\.json$/,   loader: "json-loader" },
			{ test: /\.coffee$/, loader: "coffee-loader" },
			{ test: /\.css$/,    loader: "style-loader!css-loader" },
			{ test: /\.less$/,   loader: "style-loader!css-loader!less-loader" },
			{ test: /\.jade$/,   loader: "jade-loader?self" },
			{ test: /\.png$/,    loader: "url-loader?prefix=img/" },
			{ test: /\.jpg$/,    loader: "url-loader?prefix=img/" },
			{ test: /\.gif$/,    loader: "url-loader?prefix=img/" },
			{ test: /\.woff$/,   loader: "url-loader?prefix=font/" },
			{ test: /\.eot$/,    loader: "file-loader?prefix=font/" },
			{ test: /\.ttf$/,    loader: "file-loader?prefix=font/" },
			{ test: /\.svg$/,    loader: "file-loader?prefix=font/" },
			{ test: /\.md$/,     loader: "raw-loader" },
			{ test: /\.scss$/,   loaders: ["style", "css", "sass"] }
		],
		preLoaders: []
	},
	amd: { jQuery: true },
	devtool: "#inline-source-map",
	plugins: [
		new webpack.ProvidePlugin({
			$: "jquery",
		    jQuery: "jquery",
    		"window.jQuery": "jquery",
			d3: "d3",
			_: "underscore",
			Backbone: "backbone",
			msgpack: "msgpack-js-browser"
		})
	],
	resolve: {
	  root: [
		path.resolve('./'),
	  ]
	}
};