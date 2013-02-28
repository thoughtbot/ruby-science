## Get the latest release of the book

The quickest way to start reading right now is to view the PDF version here:

<https://github.com/thoughtbot/ruby-science/raw/master/release/ruby-science.pdf>

The book is currently available in the following formats:

* PDF: [release/ruby-science.pdf](https://github.com/thoughtbot/ruby-science/raw/master/release/ruby-science.pdf)
* Single-page HTML: [release/ruby-science.html](https://github.com/thoughtbot/ruby-science/raw/master/release/ruby-science.html)
* Epub (iPad, Nook): [release/ruby-science.epub](https://github.com/thoughtbot/ruby-science/raw/master/release/ruby-science.epub)
* Mobi (Kindle): [release/ruby-science.mobi](https://github.com/thoughtbot/ruby-science/raw/master/release/ruby-science.mobi)

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

Download and install KindleGen from Amazon:

  http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000234621

You'll also need imagemagick, which you can install using homebrew:

    brew install imagemagick

Latex is needed for PDF distribution:

We recommend downloading the [smaller, BasicTeX in conjunction with MacTeX](http://www.tug.org/mactex/morepackages.html).

You may need to add its bin directory to your PATH:

    export PATH=$PATH:/usr/texbin

#### Installing dependencies on Ubuntu

Install KindleGen into ~/bin; you can put it anywhere in your PATH you like:

    wget -P /tmp/ http://s3.amazonaws.com/kindlegen/kindlegen_linux_2.6_i386_v1.2.tar.gz
    tar -C /tmp/ -xzf /tmp/kindlegen_linux_2.6_i386_v1.2.tar.gz
    mv /tmp/kindlegen ~/bin/

Latex is needed for PDF creation:

    sudo apt-get install texlive

## Building

Run `paperback build` to build all output targets.

## Contributing

New contributions should be added as pull requests. Guidelines:

* Each new, unrefactored change to the example app should be a pull request
* Each refactoring performed on the example app should be a pull request
* Each new chapter should be a pull request
* Mixing any of the above into one pull request makes reviewing more difficult

## Reviewing

When reviewing new chapters, use `bin/review` to check out, build, and view the
book locally. Example: `bin/review 6` will review the book for pull request 6.

## Releasing

Run `paperback release` to build all output targets in the `release` directory.
Then commit and push up to GitHub.
