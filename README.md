# Docker OpenGrok

Launch [OpenGrok](https://opengrok.github.io/OpenGrok/).

## Usage

Bind a volume to use [SRC_ROOT](https://github.com/OpenGrok/OpenGrok/wiki/How-to-install-OpenGrok#step0---setting-up-the-sources-having-the-web-application-container-ready) for OpenGrok.

```bash
$ docker run -d -p 8080:8080 -v /path/to/src_root:/var/opengrok/src kobtea/opengrok
```

You can change this site design like below.
Available option is [default, offwhite or polished](https://github.com/OpenGrok/OpenGrok/blob/0.12.1.5/OpenGrok#L278-L280).

```bash
$ docker run -d -p 8080:8080 -v /path/to/src_root:/var/opengrok/src -e SKIN='-L polished' kobtea/opengrok
```
