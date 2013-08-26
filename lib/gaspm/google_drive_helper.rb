module GASPM

  ##
  # Some helper methods to deal with the Google Drive API
  class GoogleDriveHelper

    # API client
    @google_client = nil
    attr_accessor :google_client

    # Discovered API object
    @google_drive = nil
    attr_accessor :google_drive


    ##
    # Constructor
    #
    # @param [Google::APIClient] client
    #  Authorized client instance
    #
    # @param [Google::APIClient::API] drive
    #  Authorized client instance
    #
    # @return [GASPM::GoogleDriveHelper]
    #  The constructed helper object.
    #
    def initialize(client, drive)
      @google_client = client
      @google_drive = drive
    end


    ##
    # Sets up the API Client and discovered API object
    #
    # @return [Google::APIClient], [Google::APIClient::API]
    #
    def self.setup

      # Create authorized client object
      client = Google::APIClient.new(
          :application_name => APP_NAME,
          :application_version => APP_VERSION
      )
      # TODO: File Storage currently not working, see https://github.com/google/google-api-ruby-client-samples/issues/4
      #file_storage = Google::APIClient::FileStorage.new(CREDENTIAL_STORE_FILE)
      #if file_storage.authorization.nil?
      client_secrets = Google::APIClient::ClientSecrets.load
      flow = Google::APIClient::InstalledAppFlow.new(
          :client_id => client_secrets.client_id,
          :client_secret => client_secrets.client_secret,
          :scope => ['https://www.googleapis.com/auth/drive']
      )
      client.authorization = flow.authorize #(file_storage)
      #else
      #  @google_client.authorization = file_storage.authorization
      #end

      # Load cached discovered API, if it exists
      drive = nil
      if File.exists? CACHED_API_FILE
        File.open(CACHED_API_FILE) do |file|
          drive = Marshal.load(file)
        end
      else
        drive = client.discovered_api('drive', API_VERSION)
        File.open(CACHED_API_FILE, 'w') do |file|
          Marshal.dump(drive, file)
        end
      end

      return client, drive

    end


    ##
    # Retrieve a list of all GAS files.
    #
    # @return [Array]
    #   List of File resources.
    #
    def retrieve_script_files
      result = Array.new
      page_token = nil
      begin
        parameters = {}
        parameters['q'] = 'mimeType=\'application/vnd.google-apps.script\''
        if page_token.to_s != ''
          parameters['pageToken'] = page_token
        end
        api_result = google_client.execute(
            :api_method => google_drive.files.list,
            :parameters => parameters
        )
        if api_result.status == 200
          files = api_result.data
          result.concat(files.items)
          page_token = files.next_page_token
        else
          puts 'An error occurred: ' + api_result.data['error']['message']
          page_token = nil
        end
      end while page_token.to_s != ''
      result
    end


    ##
    # get info for a certain file
    #
    # @param [String]
    #   Drive File Id
    #
    # @return [Google::APIClient::Schema::Drive::V1::File]
    #   Drive File instance
    #
    def retrieve_file_info(id)
      result = google_client.execute!(
          :api_method => google_drive.files.get,
          :parameters => {
              :fileId => id
          }
      )
      result.data
    end


    ##
    # Download a file's content
    #
    # @param [Google::APIClient::Schema::Drive::V1::File]
    #   Drive File instance
    #
    # @return
    #   File's content if successful, nil otherwise
    #
    def download_file(file, dl_format = 'application/vnd.google-apps.script+json')
      file_data = file.to_hash
      if file_data['exportLinks'][dl_format]
        result = google_client.execute(
            :uri => file_data['exportLinks'][dl_format]
        )
        if result.status == 200
          return result.body
        else
          puts 'An error occurred:'
          puts result.body
          return nil
        end
      else
        puts 'An error occurred: No download url available'
        return nil
      end
    end

  end

end
