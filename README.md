<img alt="Project icon" style="vertical-align: middle;" src="./docs/icon.svg" width="128" height="128" align="left">

# Deliverance

Universal document publishing system.

<br/>

[![copy CI](https://github.com/pojntfx/deliverance/actions/workflows/copy.yaml/badge.svg)](https://github.com/pojntfx/deliverance/actions/workflows/copy.yaml)
[![Matrix](https://img.shields.io/matrix/deliverance:matrix.org)](https://matrix.to/#/#deliverance:matrix.org?via=matrix.org)

## Overview

> **Deliverance**: The ship assigned to carry [Hari Seldon and his Foundation](https://foundation.fandom.com/wiki/Deliverance) to colonize the planet Terminus

Deliverance is a minimal (a single `Makefile`) digital publishing system that intents to make distributing self-contained documents, whether these are study notes, research papers, lab reports or even a bachelor's thesis, trivial. It has been in use for multiple years to create reports and study materials at [Media University Stuttgart](https://www.hdm-stuttgart.de/index_html).

It enables you to:

- **Publish using Markdown**: By using the well-supported Markdown format as its input language, Deliverance easily fits into your existing workflow.
- **Support many output formats without complicated configuration**: By default, Deliverance builds into many output formats at once - including PDF, HTML, EPUB, TXT, Gemini, ODT, DOCX, various slide formats and more!
- **Create self-contained and reproducible documents**: Deliverance creates fully self-contained and self-documenting outputs, including the full Git changelog, source repo URL, source code itself and more.
- **Integrate with CI/CD systems**: By using the Deliverance GitHub action, you can easily publish your documents to GitHub pages or other hosts.
- **Use LaTeX and BibTeX features**: Thanks to its internal use of `pandoc`, Deliverance can be used for scientific publishing.

## Examples

To make getting started with Deliverance easier, take a look at the following examples (or continue on to [Usage](#usage)):

- **Scientific Publishing**:
  - [The SolarWinds Attack and Farm-to-table Methods in the Development Process](https://github.com/pojntfx/uni-supply-chain-paper): Mitigating disasters through supply chain security by Felicitas Pojtinger (Stuttgart Media University, 2022) ([published document](https://pojntfx.github.io/uni-supply-chain-paper/))
  - [Efficient Synchronization of Linux Memory Regions over a Network: A Comparative Study and Implementation](https://github.com/pojntfx/networked-linux-memsync): A user‑friendly approach to application‑agnostic state synchronization by Felicitas Pojtinger (Stuttgart Media University, 2023) ([published document](https://pojntfx.github.io/networked-linux-memsync/))
- **Study Materials**:
  - [uni-algodat-notes](https://github.com/pojntfx/uni-algodat-notes): Notes for the Anwendungssicherheit (app security) course at HdM Stuttgart (2022) ([published document](https://pojntfx.github.io/uni-algodat-notes/)).
  - [uni-appsecurity-notes](https://github.com/pojntfx/uni-appsecurity-notes): Notes for the Anwendungssicherheit (app security) course at HdM Stuttgart (2022) ([published document](https://pojntfx.github.io/uni-appsecurity-notes/)).
  - [uni-bwl-notes](https://github.com/pojntfx/uni-bwl-notes): Notes for the Planung und Kalkulation von IT-Projekten (econ 101) course at HdM Stuttgart (2021) ([published document](https://pojntfx.github.io/uni-bwl-notes/)).
  - [uni-db1-notes](https://github.com/pojntfx/uni-db1-notes): Notes for the DB1 (databases) course at HdM Stuttgart (2021) ([published document](https://pojntfx.github.io/uni-db1-notes/)).
  - [uni-distributedsystems-notes](https://github.com/pojntfx/uni-distributedsystems-notes): Notes for the distributed systems course at HdM Stuttgart (2023) ([published document](https://pojntfx.github.io/uni-distributedsystems-notes/)).
  - [uni-hacking-notes](https://github.com/pojntfx/uni-hacking-notes): Notes for the hacking (IT-Sicherheit: Angriff & Verteidigung) course at HdM Stuttgart (2022) ([published document](https://pojntfx.github.io/uni-hacking-notes/)).
  - [uni-itsec-notes](https://github.com/pojntfx/uni-itsec-notes): Notes for the IT security course at HdM Stuttgart (2022) ([published document](https://pojntfx.github.io/uni-itsec-notes/)).
  - [uni-programminglanguages-notes](https://github.com/pojntfx/uni-programminglanguages-notes): Notes for the programming languages (Aktuelle Programmiersprachen) course at HdM Stuttgart (2023) ([published document](https://pojntfx.github.io/uni-programminglanguages-notes/)).
  - [uni-sciwriting-notes](https://github.com/pojntfx/uni-sciwriting-notes): Notes for the Anleitung zum wissenschaftlichen Arbeiten (scientific writing) course at HdM Stuttgart (2021) ([published document](https://pojntfx.github.io/uni-sciwriting-notes/)).
  - [uni-webdev-backend-notes](https://github.com/pojntfx/uni-webdev-backend-notes): Notes for the webdev backend course at HdM Stuttgart (2023) ([published document](https://pojntfx.github.io/uni-webdev-backend-notes/)).
  - [uni-webtopics-notes](https://github.com/pojntfx/uni-webtopics-notes): Notes for the Spezielle Themen für Web-Anwendungen (special topics for web applications) course at HdM Stuttgart (2022) ([published document](https://pojntfx.github.io/uni-webtopics-notes/)).
- **Lab Reports**:
  - [uni-netpractice-notes](https://github.com/pojntfx/uni-netpractice-notes): Notes for the Praktikum Rechnernetze (networking practice) course at HdM Stuttgart (2022) ([published document](https://pojntfx.github.io/uni-netpractice-notes/)).

## Tutorial

> TL;DR: Create a `configure` script, write your documents in Markdown, and publish to the web with the GitHub action

**Prefer starting with an starter project? Check out the [examples](#examples)!**

### 1. Setting Up Your Repo

First, create a new repository. On GitHub, you can do this by heading to [github.com/new](https://github.com/new), but you can also create a local repo using `git init`. After you've cloned or initialized your repo, create the `configure` script in it and make it executable:

```shell
$ tee > configure <<EOT
#!/bin/sh

curl -LO https://github.com/pojntfx/deliverance/releases/latest/download/Makefile
EOT
$ chmod +x configure
$ tee > .gitgnore <<EOT
out
Makefile
EOT
```

Once you've done that, you can use it to download the latest Deliverance `Makefile` and download the dependencies:

```shell
$ ./configure
$ make depend
```

Now, add a `LICENSE` file, a `README.md` etc. - you can find examples for this in [examples](#examples).

### 2. Writing Your Documents

Your Markdown documents should be in the `docs` folder; you can put any static assets, such as pictures, references or quotation styles, into `static/docs` - for example, you can start with this document in `docs/main.md`:

```markdown
---
author: [Felicitas Pojtinger]
date: "2023-01-28"
subject: "Uni Webdev Backend Summary"
keywords: [webdev-backend, hdm-stuttgart]
subtitle: "Summary for the webdev backend course at HdM Stuttgart"
lang: "de"
---

# Uni Webdev Backend Summary

## Meta

### Contributing

These study materials are heavily based on [professor Toenniessen's "Web Development Backend" lecture at HdM Stuttgart](https://www.hdm-stuttgart.de/bibliothek/studieninteressierte/bachelor/block?sgname=Mobile+Medien+%28Bachelor%2C+7+Semester%29&sgblockID=2573378&sgang=550041&blockname=Web+Development+Backend) and prior work of fellow students.

**Found an error or have a suggestion?** Please open an issue on GitHub ([github.com/pojntfx/uni-webdev-backend-notes](https://github.com/pojntfx/uni-webdev-backend-notes)):

![QR code to source repository](./static/qr.png){ width=150px }

If you like the study materials, a GitHub star is always appreciated :)

### License

![AGPL-3.0 license badge](https://www.gnu.org/graphics/agplv3-155x51.png){ width=128px }

Uni Webdev Backend Notes (c) 2023 Felicitas Pojtinger and contributors

SPDX-License-Identifier: AGPL-3.0
\newpage

## Themen der Vorlesung

1. **Einführung in Node.js** und einfache HTML-Fileserver
2. **RESTful Endpoints** mit Express.js
3. Die Template-Engine **EJS** und **Express-Sessions**
4. Datenbanken mit **MongoDB und Mongoose**
```

Depending on the type of document you want to write, you might also benefit from including an abstract, bibliography or more - you can find examples for this in [examples](#examples).

Once you've added your starter document (you can also add multiple ones), you can start iterating on it by running `make dev-pdf/main` - this will start compiling your notes to a PDF file on each change. You can then use `make open-pdf/main` to open the PDF file, or iterate on one of the other formats by using `make dev-html/main`, `make dev-txt/main` - there are many other `make` targets available as well, so be sure to check these out with `make <tab>`.

### 3. Publishing To The Web

To publish to the web, you can either run `make` and upload the `out/release.tar.gz` archive to your web server of choice, or use the provided GitHub action by adding the following to `.github/deliverance.yaml`:

```yaml
name: Deliverance CI

on:
  push:
  pull_request:
  schedule:
    - cron: "0 0 * * 0"

jobs:
  build-linux:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout, build and publish with Deliverance
        uses: pojntfx/deliverance@latest
        with:
          github_token: "${{ secrets.GITHUB_TOKEN }}"
```

After you've added this file, push to your repo, enable GitHub pages for the `gh-pages` branch and your documents should be accessible to everyone with an internet connection. Here is an example of a published document: [uni-supply-chain-paper](https://pojntfx.github.io/uni-supply-chain-paper/)

**🚀 You're all set to publish your documents!** We can't wait to see what you're going to share with Deliverance.

## Acknowledgements

- [pandoc](https://pandoc.org/) does most of the heavy lifting by providing the file conversion capabilities.
- [Eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template) provides the LaTeX template for PDF outputs.
- [makew0rld/md2gemini](https://github.com/makew0rld/md2gemini) enables the Markdown to Gemini conversion.

## Contributing

To contribute, please use the [GitHub flow](https://guides.github.com/introduction/flow/) and follow our [Code of Conduct](./CODE_OF_CONDUCT.md).

Have any questions or need help? Chat with us [on Matrix](https://matrix.to/#/#deliverance:matrix.org?via=matrix.org)!

## License

Deliverance (c) 2024 Felicitas Pojtinger and contributors

SPDX-License-Identifier: AGPL-3.0
