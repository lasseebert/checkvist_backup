#!/usr/bin/env ruby

require 'optparse'
require './checkvist_api.rb'
require 'tmpdir'

def get_commandline_arguments

  options = {}
   
  optparse = OptionParser.new do|opts|
    # Set a banner, displayed at the top
    # of the help screen.
    opts.banner = "Usage: checkvist_backup.rb [options]"

    # Define the options, and what they do
    options[:verbose] = false
    opts.on( '-v', '--verbose', 'Output information' ) do
     options[:verbose] = true
    end

    options[:login] = nil
    opts.on( '-l', '--login <email>', 'Your login (email)' ) do |option|
     options[:login] = option
    end

    options[:api_key] = nil
    opts.on( '-k', '--api_key <key>', 'Your API key' ) do |option|
     options[:api_key] = option
    end

    options[:output_dir] = "."
    opts.on( '-d', '--output_dir <dir>', 'Where to place the output file (defaults to current directory)' ) do |option|
     options[:output_dir] = option
    end

    options[:output_filename] = "checkvist.tar.gz"
    opts.on( '-f', '--output_filename <file>', 'Name of the output file (defaults to "checkvist.tar.gz")' ) do |option|
     options[:output_filename] = option
    end

    options[:include_archived] = false
    opts.on( '-a', '--include_archived', 'Set to include archived checklists' ) do 
     options[:include_archived] = true
    end

    # This displays the help screen, all programs are
    # assumed to have this option.
    opts.on( '-h', '--help', 'Display this screen' ) do
     puts opts
     exit
    end
  end
  optparse.parse!
  options
end

# Get options
options = get_commandline_arguments
verbose = options[:verbose]
if verbose
  puts "== OPTIONS =="
  options.each do |key, value|
    puts "#{key}: #{value}"
  end
  puts
end

# Get list of checklists
api = CheckvistApi.new options[:login], options[:api_key]
checklists = api.checklists
checklists += api.archived_checklists if options[:include_archived]
if verbose
  puts "== CHECKLISTS =="
  puts checklists.map{|x| x["name"]}
  puts
end

# Get each list as OPML
temp_files = []
temp_dir = Dir.tmpdir
checklists.each do |checklist|
  checklist_data = api.checklist_opml checklist["id"]
  file_name = "#{checklist["name"]}.opml"
  file_path = File.join(temp_dir, file_name)
  File.open(file_path, 'w') {|file| file.write checklist_data }
  temp_files << file_name

  puts "Wrote temp file #{file_path}" if verbose
end
puts "" if verbose

output_path = File.join(options[:output_dir], options[:output_filename])
system("tar c#{verbose ? "v" : ""}zf #{output_path} #{temp_files.map{|x| "-C #{temp_dir} '#{x}'"}.join(' ')}")
puts "" if verbose

temp_files.each do |file_name|
  file_path = File.join(temp_dir, file_name)
  File.delete file_path
  puts "deleted temp file #{file_path}" if verbose
end
puts "" if verbose

puts "Done! Wrote checkvist backup to #{output_path}" if verbose





