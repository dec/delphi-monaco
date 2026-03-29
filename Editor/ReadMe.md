
Note: This instructions are for developing purposes. The Delphi library will alway
include a compiled editor ready to use, so, in principle, you no need to follow the
below steps to compile the editor.

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

How to compile the editor ESM to be ready?

0º Install NodeJS if missing in the system

1º Install NPM WebPack (maybe it's required to install automatically)

2º Run the "compile.bat" file

If everything is right, the "dist" folder will contain the editor files ready to be used.

Due to what apparently is a bug, we need to do the below manually:

1º Open the "dist" folder and you will see a couple of TTF files.

2º One TTF file name is larger than the other, for example:

ef00443f4903ec1f0049.ttf
4c354c82c52ca6cc254386118520f3cd.ttf

3º Rename the file with the larger file to the file with the short name.

Finally you must get a file (following the above sample files) like:

ef00443f4903ec1f0049.ttf

... which is in fact the "4c354c82c52ca6cc254386118520f3cd.ttf", that is,
the "ef00443f4903ec1f0049.ttf" is the one expected by the editor, but, the
content of this file is placed at "4c354c82c52ca6cc254386118520f3cd.ttf".

