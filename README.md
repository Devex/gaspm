# Google Apps Script Project Manager

A small tool to sync your Google Apps Script files. Once downloaded you are able to manage the JavaScript files with a proper version control tool.

**NOTE: This tool is a work in progress and not working properly yet!**

## Get started

### Enable the Drive API

First, you need to enable the Drive API for your app. You can do this in your app's API project in the [Google APIs Console](https://code.google.com/apis/console/).

1. Create an API project in the [Google APIs Console](https://code.google.com/apis/console/).
2. Select the **Services** tab in your API project, and enable the Drive API.
3. Select the **API Access** tab in your API project, and click **Create an OAuth 2.0 client ID**.
4. In the **Branding Information** section, provide a name for the application (e.g. "Google Apps Script Project Manager"), and click **Next**.
5. In the **Client ID Settings** section, do the following:
      1. Select **Installed application** for the **Application type**
      2. Select **Other** for the **Installed application type**.
      3. Click **Create Client ID**.
6. In the **API Access** page, locate the section **Client ID for installed applications**, and click "Download JSON" and save the file as `client_secrets.json` in app directory.

### Install the dependencies

Use Bundler to install the required gems:

    $ bundle install

## Usage

Running the script will download all your GAS projects and store their files in in separate folders underneath `projects/`:

    $ ruby gaspm.rb
    # ...
    $ tree ./projects
        projects
        |-- project_1
        |   `-- Code.js
        `-- project_2
            |-- Code.js
            |-- Helper.js
            `-- Models.js

## Resources

- [Google Developers](https://developers.google.com/apps-script/import-export)
- [Google Ruby API Client](https://github.com/google/google-api-ruby-client)
- [Google Ruby API Client Samples](https://github.com/google/google-api-ruby-client-samples)

## Contributing

[Let us know on GitHub](https://github.com/Devex/gaspm/issues) when you stumble upon any bugs or issues! Of course, any ideas on improving this tool are most welcome.

If you want to contribute directly by implementing fixes or enhancements, just create a pull request!

## License

MIT License. See [LICENSE](LICENSE) for details.
