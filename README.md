# Performance Tracing For Emacs Lisp

This package for GNU Emacs allows latency tracing to be performed on
Emacs Lisp code and the results output to files using the Chromium
Catapult Trace Event Format.  These trace files can then be loaded
into trace analysis utilities in order to generate *flame graphs* and
other useful visualisations and analyses.  For example, here's a flame
graph for (a modified version of) the famous `org-agenda` function:

![image](https://user-images.githubusercontent.com/100738/96385726-9e5eb580-118d-11eb-8ded-569cf8faf9b4.png)

This package is built on top of `elp.el`, which is one of two elisp
profiler's built into emacs, the other being `profiler.el`.  (They are
both mentioned in [the Profiling section of the Elisp
manual](https://www.gnu.org/software/emacs/manual/html_node/elisp/Profiling.html).)

## Usage

### Generating a trace file

1.  Either `M-: (require 'etrace)` or add `(require 'etrace)` to your
    Emacs config, or enable the micro-feature for it if you use
    micro-features from the non-Spacemacs Emacs config.

2.  (Optional) Run `M-x customize-variable etrace-output-file` to
    change where the trace will be written.  It defaults to `~/etrace.json`.

3.  Run `M-x elp-instrument-package` and type in a function prefix to
    instrument all the functions with that prefix.  It uses a
    completion box so note that by default it will complete to
    whatever's selected in there.  If you want to complete to a prefix
    with no corresponding function, you may be able to press the Up
    arrow until the text you typed is selected rather than any
    completion, although this depends on which completion interface
    you have configured.

    There's also `M-x elp-instrument-function` for individual
    functions.

4.  Run `M-x etrace-clear`.

5.  Execute the code for which you want a trace.

6.  Run `M-x etrace-write` to write out the trace file.

### Analysing the trace file

There are several tools which can analyse the resulting trace file.
Here are some suggestions, but if you know of other good alternatives,
please submit them to this repository.

*   https://www.speedscope.app/

    This is an excellent Open Source interactive web-based flamegraph
    visualizer, which has 3 visualisation modes, keyboard shortcuts,
    lots of nice features, and good documentation.  Simply upload your
    trace file and then start analysing.

*   https://ui.perfetto.dev/

    This tool can show you the total time and percentage of time taken
    by different functions in a selection range.

*  [chrome://tracing](chrome://tracing)

    If you are using Chromium, Google Chrome, or a similar derivative,
    open this built-in tracing tool, and click the load button to open
    the trace file.  Use Alt+scroll to zoom.

If you successfully identify performance bottlenecks and fix them then
repeat from step 4, or from step 3 if any code needs to be
re-instrumented.

Finally, you can run `M-x elp-restore-all` to un-instrument any
instrumented functions.
