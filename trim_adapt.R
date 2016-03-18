trim_adapt <- function(seq,st,en,dna) {
  i <- which(seq == names(dna))
  r1 <- IRanges(start = c(st,1), end = c(en,width(dna[i])))
  r2 <- setdiff(r1[2],r1[1])
  return(c(i,start(r2),end(r2)))
}