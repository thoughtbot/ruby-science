require 'rake'
require 'nokogiri'

desc "Build all output targets, commit, and push a new release"
task :release => "build:all" do
  Releaser.new.release
end

desc "Prepare output directory"
task :prepare do
  Builder.new.prepare_output_directory
end

desc "Print page and chapter counts"
task :stats do
  total_page_count =
    `gs \
      -q \
      -dNODISPLAY \
      -c "(output/ruby-science.pdf) (r) file runpdfbegin pdfpagecount = quit"`.
      to_i
  total_chapter_count = `grep -e '^# ' book/*/*.md | wc -l`.to_i
  stub_page_count = `grep -l STUB book/*/*.md | wc -l`.to_i
  puts "Total pages: #{total_page_count}"
  puts "Complete pages: #{total_page_count - stub_page_count}"
  puts "Chapters complete: #{total_chapter_count - stub_page_count}"
  puts "Chapters remaining: #{stub_page_count}"
end

namespace :build do
  task :markdown => :prepare do
    Builder.new.generate_markdown
  end

  task :html => [:prepare, :markdown] do
    Builder.new.generate_html
  end

  task :pdf => [:prepare, :markdown] do
    Builder.new.generate_pdf
  end

  task :epub => [:prepare, :markdown] do
    Builder.new.generate_epub
  end

  task :mobi => [:prepare, :markdown, :epub] do
    Builder.new.generate_mobi
  end

  task :sample => [:prepare] do
    Builder.new.generate_sample
  end

  desc "Build all output targets"
  task :all => [:html, :pdf, :epub, :mobi, :sample, :toc] do
  end

  desc "Generate HTML table of contents for learn.thoughtbot.com"
  task :toc => :html do
    Builder.new.generate_toc
  end
end

desc "Build and open a PDF version"
task :open => 'build:pdf' do
  sh 'open output/ruby-science.pdf'
end

namespace :open do
  desc "Build and open the PDF sample"
  task :sample => 'build:sample' do
    sh 'open output/ruby-science-sample.pdf'
  end
end

module Runner
  private

  def run(command)
    puts "  + #{command}" if ENV['verbose']
    if ENV['verbose']
      puts "  - #{system command}"
    else
      system command
    end
  end
end

class Builder
  OUTPUT_DIR = "output"
  IMPORT_RAW_FILE_REGEX = /\<\<\[(.+)\]/
  IMPORT_FILE_AS_CODE_REGEX = /\<\<\((.+)\)/
  IMPORT_COMMIT_REGEX = /^` ([a-z0-9_\/]+\.[a-z\.]+)@([0-9a-f]+)(?::(\d+(?:,\d+)?))?/

  include Runner

  attr_accessor :output

  def parse_file(output, filename)
    file = File.open(filename)

    file.each do |line|
      if line =~ IMPORT_FILE_AS_CODE_REGEX
        output.puts "```"
        output.puts "# #{$1}"
        parse_file(output, "#{File.dirname(filename)}/#{$1}")
        output.puts "```"
      elsif line =~ IMPORT_RAW_FILE_REGEX
        parse_file(output, "#{File.dirname(filename)}/#{$1}")
      elsif line =~ IMPORT_COMMIT_REGEX
        output.puts "```" + import_code_highlighting($1)
        output.puts "# #{$1}"
        output.puts import_code_sample($1, $2, $3)
        output.puts "```"
      else
        output.puts line
      end
    end
  end

  def import_code_highlighting(path)
    case File.extname(path)
    when '.erb'
      'rhtml'
    else
      'ruby'
    end
  end

  def import_code_sample(path, ref, range)
    command = "git show #{ref}:example_app/#{path}"
    if range
      command << " | sed -n #{range}p"
    end

    result = `#{command}`
    if $? != 0
      exit($?.to_i)
    end
    strip_indentation(result)
  end

  # Based on ActiveSupport's strip_heredoc
  def strip_indentation(string)
    minimum_indent = string.scan(/^[ \t]*(?=\S)/).min
    indent_size = minimum_indent ? minimum_indent.size : 0
    string.gsub(/^[ \t]{#{indent_size}}/, '')
  end

  def prepare_output_directory
    puts "## Prepping output dir..."
    run "mkdir output" if !File.exists? "output"
    run "rm -rf output/*"
    run "cp -r book/images output"
  end

  def generate_markdown
    puts "## Building master Markdown book..."
    markdown = File.new("output/book.md", "w+")
    parse_file(markdown, "book/book.md")
    markdown.close
  end

  def generate_toc
    Dir.chdir OUTPUT_DIR do
      File.open 'toc.html', 'w' do |file|
        TableOfContents.new(file).write
      end
    end
  end

  def generate_html
    Dir.chdir OUTPUT_DIR do
      puts "## Generating HTML version..."
      run "pandoc book.md --section-divs --self-contained --toc --standalone -t html5 -o ruby-science.html"
    end
  end

  def generate_pdf
    Dir.chdir OUTPUT_DIR do
      puts "## Generating PDF version..."
      working = File.expand_path File.dirname(__FILE__)
      run "pandoc book.md --data-dir=#{working} --template=template --chapters --toc -o ruby-science.pdf"
    end
  end

  def generate_sample
    markdown = File.new("output/sample.md", "w+")
    parse_file(markdown, "book/sample.md")
    markdown.close
    Dir.chdir OUTPUT_DIR do
      puts "## Generating Sample PDF version..."
      working = File.expand_path File.dirname(__FILE__)
      run "pandoc sample.md --data-dir=#{working} --template=template --chapters --toc -o ruby-science-sample.pdf"
    end
  end

  def generate_epub
    Dir.chdir OUTPUT_DIR do
      puts "## Generating EPUB version..."
      run "convert -density 400 -resize 1000x1000 images/cover.pdf images/cover.png"
      run "pandoc book.md --toc --epub-cover-image=images/cover.png -o ruby-science.epub"
    end
  end

  def generate_mobi
    Dir.chdir OUTPUT_DIR do
      puts "## Generating MOBI version..."
      run "kindlegen ruby-science.epub -o ruby-science.mobi"
    end
  end
end

class TableOfContents
  EXCLUDE = [
    'Symptoms', 'Example', 'Solutions', 'Prevention', 'Uses', 'Steps',
    'Next Steps', 'Drawbacks'
  ]
  PARTS = ['Code Smells', 'Solutions', 'Principles']

  def initialize(file)
    @file = file
  end

  def write
    add_work_in_progress_notations
    remove_excluded_headers
    remove_anchors
    remove_deep_headers
    write_header
    write_introduction
    write_parts
    write_footer
  end

  private

  def add_work_in_progress_notations
    toc_element.css('a').each do |anchor|
      href = anchor['href']
      target = document.css(href).first
      if target.text.include?('STUB')
        anchor.content = "#{anchor.content}*"
      end
    end
  end

  def remove_excluded_headers
    toc_element.css('li').each do |item|
      if EXCLUDE.include?(item.text)
        item.remove
      end
    end
  end

  def remove_anchors
    toc_element.css('a').each do |anchor|
      anchor.replace anchor.children.first
    end
  end

  def remove_deep_headers
    toc_element.css('li ul').each(&:remove)
  end

  def write_introduction
    write_chapters 1
  end

  def write_parts
    PARTS.each do |part|
      write_part part, count_chapters_for(part)
    end
  end

  def write_part(part, chapters_count)
    @file.puts '<li>'
    @file.puts "<h3>#{part}</h3>"
    @file.puts '<ul>'
    write_chapters chapters_count
    @file.puts '</ul>'
    @file.puts '</li>'
  end

  def count_chapters_for(part)
    directory = part.downcase.gsub(' ', '_')
    `ls ../book/#{directory}/*.md | wc -l`.to_i
  end

  def write_chapters(chapters_count)
    chapters_count.times do
      chapter = chapters.first
      chapter.remove
      @file.puts chapter.to_s
    end
  end

  def write_header
    @file.puts '<section id="table-of-contents">'
    @file.puts '<h3>Table of Contents</h3>'
    @file.puts '<ul>'
  end

  def write_footer
    @file.puts '</ul>'
    @file.puts '</section>'
  end

  def html
    IO.read('ruby-science.html')
  end

  def document
    @document ||= Nokogiri::HTML::Document.parse(html)
  end

  def chapters
    document.css('#TOC > ul > li')
  end

  def toc_element
    @toc_element ||= document.css('#TOC > ul')
  end
end

class Releaser
  include Runner

  def release
    Dir.chdir File.dirname(__FILE__)
    ensure_clean_git
    copy_output_folder_to_release_folder
    commit_release_folder
    push
  end

  def ensure_clean_git
    raise "Can't deploy without a clean git status." if git_dirty?
  end

  def copy_output_folder_to_release_folder
    puts "## Making release..."
    run "rm -rf release"
    run "cp -R output release"
  end

  def commit_release_folder
    puts "## Commit release..."
    run "git add -u && git add . && git commit -m 'Generate new release'"
  end

  def push
    puts "## Pushing release..."
    run "git push"
  end

  private

  def git_dirty?
    `[[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]`
    dirty = $?.success?
  end
end
