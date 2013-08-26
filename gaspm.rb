require 'rubygems'
require 'google/api_client'
require 'google/api_client/client_secrets'
#require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'json'
require './lib/gaspm/google_drive_helper'
require 'pp'

APP_NAME = 'Google Apps Script Project Manager'
APP_VERSION = '0.1.0'
API_VERSION = 'v2'
CACHED_API_FILE = "./.data/drive-#{API_VERSION}.cache"
CREDENTIAL_STORE_FILE = "./.data/#{$0}-oauth2.json"

if (!File.directory? './.data')
  FileUtils.mkdir_p './.data'
end
if (!File.directory? './projects')
  FileUtils.mkdir_p './projects'
end

client, drive = GASPM::GoogleDriveHelper.setup
connector = GASPM::GoogleDriveHelper.new(client, drive)

puts '- getting file list'
files = connector.retrieve_script_files()
puts '  -> got info for ' + files.count.to_s + ' files.'
files.each { |file|
    puts '- downloading ' + file.title
    #PP.pp(file.to_hash)
    file_content = connector.download_file(file)
    puts '  -> done'
    puts file_content
}
