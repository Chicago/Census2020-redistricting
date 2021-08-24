
## Function to write JSON summary to a temp file.

## For example, to copy examples of a column summary to a file when 
## creating a data dictionary. 
##
## Note, the names are removed because it's assumed that you're putting this 
## into context.
##
##
##
# ## Example: 
# ## 1 - Convert mtcars to data.table
# ## 2 - Create a summary of gear / cyl
# ## 3 - put it in a temp file
# ## 4- open the file
#
# require(data.table)
# mtcars %>% data.table %>% .[,.N,list(gear, cyl)] %>% jsontotempfile


jsontotempfile <- function(x, outfile=tf) {
    
    require(magrittr)
    
    if(!exists("tf") | is.null(tf)){
        tf <- tempfile() %>% paste0(.,".txt")
    }
    
    ## Write x (as json) to a temp file
    x %>% unname %>% jsonlite::toJSON() %>% cat(., file=outfile)
    
    ## Open that file in the shell 
    shell.exec(outfile)
    
    "Copy this command to clean up file later:\n unlink(%s)\n" %>% 
        sprintf(., tf %>% encodeString %>% shQuote ) %>% 
        cat()
    
    return(NULL)
}

