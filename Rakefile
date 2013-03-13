require 'rake'
require 'nokogiri'

desc "Print page and chapter counts"
task :stats => :build do
  total_page_count =
    `gs \
      -q \
      -dNODISPLAY \
      -c "(build/ruby-science.pdf) (r) file runpdfbegin pdfpagecount = quit"`.
      to_i
  total_chapter_count = `grep -e '^# ' book/*/*.md | wc -l`.to_i
  stub_page_count = `grep -l STUB book/*/*.md | wc -l`.to_i
  puts "Total pages: #{total_page_count}"
  puts "Complete pages: #{total_page_count - stub_page_count}"
  puts "Chapters complete: #{total_chapter_count - stub_page_count}"
  puts "Chapters remaining: #{stub_page_count}"
end

desc "Generate the book using paperback"
task :build do
  sh 'paperback build'
end

desc "Generate HTML table of contents for learn.thoughtbot.com"
task :toc => :build do
  Dir.chdir 'build' do
    File.open 'toc.html', 'w' do |file|
      TableOfContents.new(file).write
    end
  end
end

desc "Build and open a PDF version"
task :open => :build do
  sh 'open build/ruby-science.pdf'
end

namespace :open do
  desc "Build and open the PDF sample"
  task :sample => :build do
    sh 'open build/sample.pdf'
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
