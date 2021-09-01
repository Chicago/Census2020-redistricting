normalize_vars <- function(df, vars, ref){
    
    ## Convert input to data.frame, but 
    ## convert output to data.table on exit 
    if("data.table "%in% class(df)){
        df <- as.data.frame(df)
        on.exit(ret <- as.data.table(ret))
    }
    
    ret <- df[ , vars]
    
    for(v in vars){
        ret[,v] <- df[,v] / df[,ref]
    }
    
    return(ret)
}
