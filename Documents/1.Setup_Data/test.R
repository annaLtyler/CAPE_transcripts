env.names <- names(env)

search.term = "tree"

for(i in 1:length(env.names)){
    test  <- get(env.names[i], envir = env)
    test.class <- class(test)
    if(test.class[1] == "list"){
        test.names <- names(test)
        term.idx <- grep(search.term, test.names)
        #test.names[term.idx]
        found.term <- as.logical(length(term.idx))
        if(found.term){print(paste(i, env.names[i]))}
    }
}
