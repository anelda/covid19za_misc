#!/usr/bin/Rscript --vanilla

## INSTALL PACKAGES REQUIRED FOR SCRIPT TO EXECUTE - uncomment if installation is required ----
# install.packages('devtools')
# devtools::install_github("tidyverse/googlesheets4")
# install.packages(readr)
# install.packages('optparse')

## SET UP AUTHENTICATION FOR GOOGLE SHEETS/R ----

# 1. Create a new project in Google Developer Console
# 2. Click on the Google APIs logo to get back to get to the login page)
# 3. Click on Credentials - on the left side menu 
# 4. Ensure your new project is selected (the project name is displayed top left next to Google APIs logo)
# 5. Click on 'Create Credentials' - middle top of page
# 6. Select 'Create Service Account' from drop down menu
# 7. Type name for service account e.g. covid19za-sync-sheet then
# 8. Click on 'Create'
# 9. Skip step to add roles (unless you want to specify)
# 10. Skip step to grant users access (unless other users should access)
# 11. Click on 'Create Key' (bottom of page)
# 12. Select 'JSON'
# 13. Click on 'Create'
# 14. Save the file in a SECURE place where you can reference it later
# 15. Enable Google Sheets API for the project by going back to the home page (Click on the Google APIs logo top left)
#     - Click on 'Library' - left side menu
#     - Search for 'Google Sheet API'
#     - Click on 'Enable'
# Reference for these instructions: https://gargle.r-lib.org/articles/get-api-credentials.html under \'Service Account Token\ and 
# https://github.com/tidyverse/googlesheets4/issues/27 - see comment by leerssej on Jun 30, 2019

## LOAD REQUIRED LIBRARIES ----

suppressPackageStartupMessages(require(optparse))
suppressPackageStartupMessages(require(googlesheets4))
suppressPackageStartupMessages(require(readr))

## CREATE ARGUMENTS TO RUN SCRIPT ON THE COMMAND LINE (IF RUN FROM RSTUDIO COMMENT THESE LINES OUT) ----

option_list = list(
  make_option(c("-g", "--goog_account"), type="character", default="anelda.vdwalt@gmail.com", 
              help="Google email for account that should be used", metavar="character"),
  make_option(c("-i", "--googsheet_id"), type="character", default=NULL, 
              help="Target Google Sheet ID or shared URL that contains the ID", metavar="character"),
  make_option(c("-d", "--csv_data"), type="character", default = NULL,
              help="Source CSV file either as URL to the raw data or with full path to locally stored data", metavar = "character"),
  make_option(c("-n", "--googsheet_name"), type="character", default = "Sheet1",
              help="The name of the actual sheet in the file - if not provided the script will create a new sheet in the doc. [default = %default]"),
  make_option(c("-k", "--key"), type="character", default = NULL,
              help="File path and file name of Google Service Account Key created in the steps described in this R script and at https://gargle.r-lib.org/articles/get-api-credentials.html under \'Service Account Token\'")
) 
 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

# Handling empty arguments

if (is.null(opt$goog_account)){
  print_help(opt_parser)
  stop("Please provide a valid Google account email", call.=FALSE)
}
if (is.null(opt$googsheet_id)){
  print_help(opt_parser)
  stop("Please provide a valid Google Sheet ID", call.=FALSE)
}
if (is.null(opt$csv_data)){
  print_help(opt_parser)
  stop("Please provide a valid CSV data source file", call.=FALSE)
}

# PROVIDE GOOGLE SHEET CONTEXT AND ORIGINAL CSV FILE (IF NOT RUN ON THE COMMANDLINE - e.g. FROM RSTUDIO - UNCOMMENT) ----

# # Replace goog_sheet with shared link to target google sheet or target google sheet ID
# goog_sheet <- 'https://docs.google.com/spreadsheets/d/1hJGFPEXfDRT2eOSUtZ8rR2ykf4xf76wR1wRvgNyw6gs/edit?usp=sharing'
# # Replace csv_data with source CSV URL or file name
# csv_data <- read_csv('https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_timeline_confirmed.csv')
# # Must provide sheet name to ensure overwrite and prevent the creation of new sheets within Google Sheet file
# # Replace sheet_name with target google sheet name (default first sheet is Sheet1)
# sheet_name <- 'Sheet1'

## AUTHORISE R TO ACCESS GOOGLE DRIVE ----
# Provide the path to where the JSON Service Account Key is stored (to get this key, see notes at top of script)
sheets_auth(path = opt$key)

## CREATE DATAFRAME FROM CSV FILE FOR WRITING TO GOOGLE SHEETS ----
csv_df <- read_csv(opt$csv_data)

## WRITE DATA TO TARGET SPREADSHEET ----
sheets_write(csv_df, ss = opt$googsheet_id, sheet = opt$googsheet_name)
