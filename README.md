# Delphi library for Monaco Editor #

This Delphi library allows to use the Monaco Editor (https://microsoft.github.io/monaco-editor/)
in our Delphi developed programs. The library has been only tried in Delphi 10.4, and, probably
can work as expected in later Delphi versions.

This library provide to you with some Delphi classes which try to encapsulate some of the
features of the Monaco Editor (not all of them). Additionally, this library provide the right
HTML and JavaScript code of the "editor app", which is used by the Delphi library under the hood.

The project also includes a demo program as the only documentation (apart some comments) of
the library. All the source code is included, from the HTML and JavaScript to the Delphi code.


### Requisites ###

This library uses (see more below at the Attribution topic) the WebView4Delphi library, so
you need to have it installed in Delphi. You can get the latest version of WebView4Delphi
from their GitHub page at: https://github.com/salvadordf/WebView4Delphi

The demo program included with this library uses FastMM5 (https://github.com/pleriche/FastMM5)
to avoid memory leaks: you can install it in your Delphi (if missing) or just comment the usage
of the FastMM5 unit at the "DPR" file of the demo program.


### How to use ###

Just include in your Delphi project the units that you can found at the "DecSoft.Monaco" folder.

Then, you also will need to distribute with your program the HTML and JavaScript editor, that
you can found at the "\DecSoft.Monaco\editor\" folder.

You can place the content of the "editor" folder wherever you want: later in your Delphi program
you can set the right "property" to the path of the folder which contains the files.

Follow how the library is used at the demo program which is included at the "Demo" folder.


### Use cases ###

This library is used by a project of mine: DecSoft App Builder, and, in fact, has been intended
to this project from the very beginning. If you are interested in this project you can download
from my website at: https://www.decsoftutils.com/


### MIT license ###

Copyright (c) DecSoft Utils - https://www.decsoftutils.com/

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


### Attribution ###

Even when it's possible to use the WebView2 (TEdgeBrowser) included in Delphi, I prefer to use
the WebView4Delphi library for this project. I really appreciate the work that Salvador Díaz Fau
do developing and keeping well maintained the WebView4Delphi library.

https://github.com/salvadordf/WebView4Delphi


Of course I also appreciate so much the work of the developers of Monaco Editor, who provide
to us probably the best source code editor in the world.

https://microsoft.github.io/monaco-editor/

https://github.com/microsoft/monaco-editor


### Donate ###

All donations to help support this project are very welcome: https://www.paypal.me/davidesperalta

