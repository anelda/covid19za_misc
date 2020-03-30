## INSTALL PACKAGES REQUIRED FOR SCRIPT TO EXECUTE - uncomment if installation is required ----
# install.packages('devtools')
# devtools::install_github("tidyverse/googlesheets4")
# install.packages(tidyverse)

## LOAD LIBRARIES ----
library(googlesheets4)
library(googledrive)
library(tidyverse)

# PROVIDE GOOGLE SHEET CONTEXT AND ORIGINAL CSV FILE ----

# Replace goog_sheet with shared link to target google sheet or target google sheet ID
goog_sheet <- 'https://docs.google.com/spreadsheets/d/1hJGFPEXfDRT2eOSUtZ8rR2ykf4xf76wR1wRvgNyw6gs/edit?usp=sharing'
# Replace csv_data with source CSV URL or file name
csv_data <- read_csv('https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_timeline_confirmed.csv')
# Must provide sheet name to ensure overwrite and prevent the creation of new sheets within Google Sheet file
# Replace sheet_name with target google sheet name (default first sheet is Sheet1)
sheet_name <- 'Sheet1'

## AUTHORISE R TO ACCESS GOOGLE DRIVE ----

# By default, you are directed to a web browser, asked to sign in to your Google account, 
# and to grant googlesheets4 permission to operate on your behalf with Google Sheets. 
# By default, these user credentials are cached in a folder below your home directory, 
#~/.R/gargle/gargle-oauth, from where they can be automatically refreshed, as necessary. 
# Storage at the user level means the same token can be used across multiple projects and 
# tokens are less likely to be synced to the cloud by accident.
# This will allow the owner of the Google Drive to authorise R to access the drive files
# Source: https://googlesheets4.tidyverse.org/reference/sheets_auth.html

sheets_auth(
  email = gargle::gargle_oauth_email(),
  path = NULL,
  scopes = "https://www.googleapis.com/auth/spreadsheets",
  cache = gargle::gargle_oauth_cache(),
  use_oob = gargle::gargle_oob_default(),
  token = NULL
)
# WRITE DATA TO TARGET SPREADSHEET ----
sheets_write(csv_data, ss = goog_sheet, sheet = sheet_name)
