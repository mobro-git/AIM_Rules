####################################################
############   Supporting function to download files
####################################################

## downloads a file if not present locally and extracts the contents if it is a
## compressed archive

## inputs:
##   url: url where the remote file resides
##   file_name: name of the remote file
##   dir: local directory to save the file [defulat is "."]
##   check_file: optional name of local file, where if present the download will
##              not occur. useful if the remote file is a compressed archive and
##               it shouldn't be downloaded if its contents is already present
##   tolower: covnert file names in a zip file to lower case [default is FALSE]
# 
download_file = function(url,file_name,dir=".",check_file=NA,tolower=F) {
  
  library(httr)
  
  # create the directory if needed
  if (!dir.exists(dir))
    dir.create(dir)
  
  # if no check file name is provided use the remote file name
  if (is.na(check_file))
    check_file = file_name
  
  # if the check file is present then do nothing further
  if (file.exists(file.path(dir,check_file)))
    return()
  
  # download the file
  cat(paste0("downloading ",file_name,"... \n"))
  GET(paste0(url,file_name),
      write_disk(file.path(dir,file_name),overwrite=TRUE),
      progress())
  
  # if the file is a zip archive extract the contents and delete the archive
  if (tools::file_ext(file_name)=="zip") {
    cat("extracting zip file...\n")
    unzip(file.path(dir,file_name),exdir=dir)
    if (tolower) {
      files = unzip(file.path(dir,file_name),list=T)
      for (file in files)
        file.rename(file.path(dir,file),file.path(dir,tolower(file)))
    }
    file.remove(file.path(dir,file_name))
  }
  
  cat("\n")
  #   
}

