
####################################################
############   NATA cancer and respiratory risk data
####################################################

# directory to store the nata data
nata_dir = "data\\nata_data"

# 2014(2017) nata file containing national cancer risks by toxic
#nata_file = "nata2014v2_national_cancerrisk_by_tract_poll.xlsx"
nata_file = "national_cancerrisk_by_tract_poll.xlsx"


# # download the nata data if it doesn't already exist
# download_file("https://www.epa.gov/sites/production/files/2018-08/",
download_file("https://www.epa.gov/system/files/other-files/2022-03/",
               nata_file,
               dir=nata_dir)

# # Respiratory 
nata_file_resp =  "national_resphi_by_tract_poll.xlsx"

download_file("https://www.epa.gov/sites/production/files/2022-03/",
               nata_file_resp,
               dir=nata_dir)

