# Performance Tracing For Emacs

## How To Use It

1. Either M-: (require 'etrace) or add (require 'etrace) to your Emacs config, or enable the micro-feature for it if you use micro-features from the non-Spacemacs Emacs config.
(Optional) Run M-x customize-variable etrace-output-file to change where the trace will be written, it defaults to ~/etrace.json
2. Run M-x elp-instrument-package and type in a function prefix to instrument all the functions with that prefix. It uses a completion box so note that by default it'll complete to whatever's selected in there, if you want to complete to a prefix with no corresponding function you can press the up arrow until the text you typed is selected rather than any completion. There's also M-x elp-instrument-function for individual functions.
3. Run M-x etrace-clear
4. Do the thing you want a trace of
5. Run M-x etrace-write to write out the trace file.
6. Go to chrome://tracing in Chrome and click the load button and open the trace file. Use alt+scroll to zoom. Alternatively use https://ui.perfetto.dev/#!/ which is also good but in different ways, for example it can show you the total time and percentage of time taken by different functions in a selection range.
7. Make some changes and then repeat from step 4.
8. Run M-x elp-restore-all to un-instrument any instrumented functions