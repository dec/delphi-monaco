
This folder contains the HTML and JavaScript code which implement the
Monaco Editor used by the Delphi library for Monaco Editor.

The main HTML and JavaScript code are placed at the "app" folder.

The Delphi library for Monaco Editor is published with a compiled version
of the app, but, it's also possible to compile the editor app with the 
stuff of this folder.

At the "webpack.config.js" file we can specify the version of Monaco Editor
that we want to use when compile the app.

If we need to modify or enhance the editor app, we must edit the files placed
at the "app" folder.

Once we modify the app, we must copy the "app\editor.html" and "app\favicon.ico"
into the "dist" folder.

Then we must folow the below steps to compile the editor app to be ready to
use with the Delphi library for Monaco Editor:

0º NodeJS is required, and, probably you must install "webpack" too if not available.

1º Open a CMD console on this folder.

2º Run: npm install

3º Run: npm run build

If everything is OK, you must have all the required files at the "dist" folder.

You can then copy the files from the "dist" to "..\DecSoft.Monaco\editor\"

Note, however, that the location of the editor is intended to be used by the
demo program of the Delphi library for Monaco Editor: if you use this library
in your program, you must redistribute the files from the "dist" (or the
"..\DecSoft.Monaco\editor\".

The demo program shows you how we can specify the path for the editor folder,
so, the folder can be in any place, and you can point to it accordingly. 
 
