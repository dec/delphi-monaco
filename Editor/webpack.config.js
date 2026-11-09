const path = require('path');
const MinimizerPlugin = require("minimizer-webpack-plugin");

module.exports = {
 optimization: {
			minimize: true,
		 chunkIds: 'named',
			minimize: true,
   minimizer: [new MinimizerPlugin()]
 },
	mode: 'production',
	entry: {
		app: './app/editor.js',
		'editor.worker': 'monaco-editor/editor/editor.worker.js',
		'json.worker': 'monaco-editor/language/json/json.worker.js',
		'css.worker': 'monaco-editor/language/css/css.worker.js',
		'html.worker': 'monaco-editor/language/html/html.worker.js',
		'ts.worker': 'monaco-editor/language/typescript/ts.worker.js'
	},
	output: {
		globalObject: 'self',
		filename: '[name].bundle.js',
		path: path.resolve(__dirname, 'dist')
	},
	module: {
		rules: [
			{
				test: /\.css$/,
				use: ['style-loader', 'css-loader']
			},
			{
				test: /\.ttf$/,
				use: ['file-loader']
			}
		]
	}
};
