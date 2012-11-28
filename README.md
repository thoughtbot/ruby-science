## Get the latest release of the book

The quickest way to start reading right now is to view the PDF version here:

<https://github.com/thoughtbot/ruby-science/raw/master/release/book.pdf>

The book is currently available in the following formats:

* PDF: [release/book.pdf](https://github.com/thoughtbot/ruby-science/raw/master/release/book.pdf)
* Single-page HTML: [release/book.html](https://github.com/thoughtbot/ruby-science/raw/master/release/book.html)
* Epub (iPad, Nook): [release/book.epub](https://github.com/thoughtbot/ruby-science/raw/master/release/book.epub)
* Mobi (Kindle): [release/book.mobi](https://github.com/thoughtbot/ruby-science/raw/master/release/book.mobi)

For the HTML version, clone the repository and look at the HTML so that images
and other assets are properly loaded.

## Instructions for authors

#### Note: Readers of the book don't need to worry about the instructions below.

This book is written using using the markdown and built using pandoc, which can
be found at:

<http://johnmacfarlane.net/pandoc/>

Instructions for installing pandoc for your platform can be found here:

<http://johnmacfarlane.net/pandoc/installing.html>

We recommend using the binary distribution of pandoc whenever possible.

### Dependencies

Install dependencies with Bundler:

    bundle install

Now install the pandoc dependencies:

#### Installing dependencies on OSX

    brew install https://raw.github.com/adamv/homebrew-alt/master/non-free/kindlegen.rb
    brew install imagemagick

Latex is needed for PDF distribution:

We recommend downloading the [smaller, BasicTeX in conjunction with MacTeX](http://www.tug.org/mactex/morepackages.html).

#### Installing dependencies on Ubuntu

Install KindleGen into ~/bin; you can put it anywhere in your PATH you like:

    wget -P /tmp/ http://s3.amazonaws.com/kindlegen/kindlegen_linux_2.6_i386_v1.2.tar.gz
    tar -C /tmp/ -xzf /tmp/kindlegen_linux_2.6_i386_v1.2.tar.gz
    mv /tmp/kindlegen ~/bin/

Latex is needed for PDF creation:

    sudo apt-get install texlive

## Building

Run `rake build:all` to build all output targets.

Run `rake build:epub` (or `:html`, `:pdf`, `:mobi`) to build individual versions.

## For Authors

New contributions should be added as pull requests. Guidelines:

* Each new, unrefactored change to the example app should be a pull request
* Each refactoring performed on the example app should be a pull request
* Each new chapter should be a pull request
* Mixing any of the above into one pull request makes reviewing more difficult

When reviewing new chapters, use `bin/review` to check out, build, and view the
book locally. Example: `bin/review 6` will review the book for pull request 6.

## Releasing

Run `rake release` to build all output targets, commit to git, and push up to
GitHub.
