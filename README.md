# Containerised KiCad

This repository contains a Docker container which installs the latest release
candidate of the KiCad electronic design automation suite.

The meat of the repo is the [kicad.sh](kicad.sh) script. Ensure you have docker
installed and available. You must also be running the X windowing system. (If
you're running Linux, this is almost certainly true.)

The wrapper script does not need the rest of the repo so one can simply execute
KiCad via:

```console
$ curl -O -L https://github.com/rjw57/kicad-docker/raw/master/kicad.sh
$ bash kicad.sh /path/to/your/project.pro
```

**IMPORTANT**: The launched KiCad will only have access to the contents of the
project directory.

