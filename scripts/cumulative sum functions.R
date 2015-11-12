library(RJDBC)
# drv <- JDBC("org.postgresql.Driver", "C:/sql_workbench/postgresql-8.4-703.jdbc4.jar")
drv <- JDBC("org.postgresql.Driver", "C:/sql_workbench/postgresql-9.3-1102.jdbc4.jar") # also works
conn <- dbConnect (drv, "jdbc:postgresql://10.100.148.32:5432/dodobase", "fsu", "fsurocks")

# grab data, syntax = (server connection, schema.table) # soil pit schema = "biomass_neon"
# soil_biomass <- dbReadTable(conn, "biomass_neon.soil_pit_biomass") ## this table has duplicates
soil_biomass2 <- dbReadTable(conn, "biomass_neon.soil_pit_biomass2") # updated data with no duplicates
ddply(soil_biomass, .(site_id,profile, depth), summarize, cumsum(fine_root_mass))

# just use one site
z <- filter(soil_biomass, site_id %in% c("D01BART", "D02BLAN"), profile == '1') %>% select(site_id, profile, lower_depth, mg_cm_3)

# running cumulative total of root mass
ddply(z, .(site_id), transform, cumulative_mass = cumsum(mg_cm_3))

# sum total of all roots in a single profile
ddply(z, .(site_id), transform, profile_total_mass = sum(mg_cm_3))

# what happens when you reverse the order?
z_reverse <- z[order(z$lower_depth, decreasing = TRUE),]
ddply(z_reverse, .(site_id), transform, cumulative_mass = cumsum(mg_cm_3))




# a for loop try - works correctly if the "storage" vector is completely empty i.e. has no values in it whatsoever
# http://stackoverflow.com/questions/15889131/how-to-find-the-cumulative-sum-of-numbers-in-a-list
x <- data.frame(y = c(1,2,3,4,5), group = rep("a", 5))
cumsum(x$y)

# for loop example
csum <- c() # create a totally empty vector, with no values
total = 0
for (v in x$y){
  print(csum)
  total = total + v
  csum <-  c(csum,total) # now fill that vector with each iteration
};csum


# a fibonacci type problem
# https://technobeans.wordpress.com/2012/04/16/5-ways-of-fibonacci-in-python/

fibo <- function(n){
  a = 1
  b = 1
  for (i in range(n-1)){
    a = b
    b = a + b
    print(a)
  }
}

fibo(10)


len <- 10
fibvals <- numeric(len)
fibvals[1] <- 1
fibvals[2] <- 1
for (i in 3:len) { 
  fibvals[i] <- fibvals[i-1]+fibvals[i-2]
}
fibvals
