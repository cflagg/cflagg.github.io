```{r}

test2 <- data.frame(siteID = c("BART","BART","CPER","CPER", "DSNY", "DSNY"), sampleVolume = c(1,2,3,4,5,""))

if (any(is.na(test2$sampleVolume))){
  print("danger")
}else if(any(test2$sampleVolume <= 0)) {print("zeroes")
}else if (any(test2$sampleVolume == " " | any(test2$sampleVolume == ""))){print("blanks")
}else{print("pass")}


```