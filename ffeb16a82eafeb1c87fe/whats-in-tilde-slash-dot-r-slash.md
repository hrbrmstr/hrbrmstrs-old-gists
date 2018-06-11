What's in `~/.R/`?

- `~/.R/check.Renviron` (and arch-specific extensions)
- `~/.R/build.Renviron` (and arch-specific extensions)
- `~/.R/Makevars`
- `~/.R/config`
- `~/.R/licensed`

Also: RStudio plans on stuffing more (sharable) things into the ~/.R folder; e.g. custom shortcuts, commands, etc. (mostly cuz Kevin Ushey is OUT OF CONTROL!)

Some deets:

-------

<https://stat.ethz.ch/R-manual/R-devel/library/base/html/Startup.html>

`R CMD check` and `R CMD build` do not always read the standard startup files, but they do always read specific `Renviron` files. The location of these can be controlled by the environment variables `R_CHECK_ENVIRON` and `R_BUILD_ENVIRON`. If these are set their value is used as the path for the `Renviron` file; otherwise, files `~/.R/check.Renviron` or `~/.R/build.Renviron` or sub-architecture-specific versions (i.e. `~/.R/check.Renviron.i386`) are employed.

-------

<https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Using-Address-Sanitizer>

### 4.3.3 Using the Address Sanitizer

AddressSanitizer (‘ASan’) is a tool with similar aims to the memory checker in valgrind. It is available with suitable builds of gcc 4.8.0 or clang 3.1 and later on common Linux and OS X platforms. See <http://clang.llvm.org/docs/UsersManual.html#controlling-code-generation>, <http://clang.llvm.org/docs/AddressSanitizer.html> and <https://code.google.com/p/address-sanitizer/>.

It requires code to have been compiled and linked with `-fsanitize=address`, and compiling with `-fno-omit-frame-pointer` will give more legible reports. It has a runtime penalty of 2–3x, extended compilation times and uses substantially more memory, often 1–2GB, at run time. On 64-bit platforms it reserves (but does not allocate) 16–20TB of virtual memory: restrictive shell settings can cause problems.

By comparison with valgrind, ASan can detect misuse of stack and global variables but not the use of uninitialized memory.

gcc as from version 4.9.0 returns symbolic addresses for the location of the error, but most other versions do not. For the latter, one possibility is to use an external symbolizer. Depending on the version, this can be done via an environment variable, e.g.

    ASAN_SYMBOLIZER_PATH=/path/to/llvm-symbolizer

or by piping the output through `asan_symbolize.py` and perhaps then (for compiled C++ code) `c++filt`.

The simplest way to make use of this is to build a version of R with something like

    CC="gcc-4.9 -std=gnu99 -fsanitize=address"
    CFLAGS="-fno-omit-frame-pointer -g -O2 -Wall -pedantic -mtune=native"

which will ensure that the libasan run-time library is compiled into the R executable. However this check can be enabled on a per-package basis by using a `~/.R/Makevars` file like

    CC = gcc-4.9 -std=gnu99 -fsanitize=address -fno-omit-frame-pointer
    CXX = g++-4.9 -fsanitize=address -fno-omit-frame-pointer
    F77 = gfortran-4.9 -fsanitize=address
    FC = gfortran-4.9 -fsanitize=address

(Note that `-fsanitize=address` has to be part of the compiler specification to ensure it is used for linking. These settings will not be honoured by packages which ignore `~/.R/Makevars`.) It will be necessary to build R with

    MAIN_LDFLAGS = -fsanitize=address

to link the runtime libraries into the R executable if it was not specified as part of `CC` when R was built.

-------

<https://cran.r-project.org/doc/manuals/r-release/R-admin.html#Configuration-variables>

### B.3 Configuration variables

If you need or want to set certain configure variables to something other than their default, you can do that by either editing the file `config.site` (which documents many of the variables you might want to set: others can be seen in file `etc/Renviron.in`) or on the command line as

    ./configure VAR=value

If you are building in a directory different from the sources, there can be copies of config.site in the source and the build directories, and both will be read (in that order). In addition, if there is a file `~/.R/config`, it is read between the `config.site` files in the source and the build directories.

-------

<https://stat.ethz.ch/R-manual/R-devel/library/base/html/library.html>

### Licenses

Some packages have restrictive licenses, and there is a mechanism to allow users to be aware of such licenses. If `getOption("checkPackageLicense") == TRUE`, then at first use of a package with a not-known-to-be-FOSS (see below) license the user is asked to view and accept the license: a list of accepted licenses is stored in file `~/.R/licensed`. In a non-interactive session it is an error to use such a package whose license has not already been accepted.