{
  require(xlsx)
  require(here)
  require(data.table)
  require(spData)
  require(sf)
  require(ggplot2)
  class(us_states)
}




{
  evaluated_file = here("data", "wra", "Evaluated Species.xlsx")
  evaluated_file = here("data", "wra", "Evaluated Species.csv")
  
  by_state = fread(evaluated_file, skip = 1)
  
  file.exists(evaluated_file)
  
  # xlsx files not formatted in a readable way:
  {
    
    read.xlsx2(evaluated_file, 2)
    read.xlsx(evaluated_file, 4, startRow = 2)
    read.xlsx2(evaluated_file, "By speciesstate")
  }  
}


# State polygons
{
  names(us_states)
  head(us_states)
  
  state_names_ne = c( "New York", "Massachusetts", "Connecticut", "Maine", "New Hampshire", "Rhode Island", "Vermont")
  state_abbr_ne = c("NY", "MA", "CT", "ME", "NH", "RI", "VT")
  
  
  
  state_names = c("New York", "Massachusetts", "Maine", "New Hampshire")
  state_abbr = c("NY", "MA", "ME", "NH")
  
  setdiff(state_names_ne, state_names)
  
  
  ne_states = subset(us_states, NAME %in% state_names_ne)
  ne_states = cbind(ne_states, state_abbr = state_abbr_ne)
  
  ne_states = subset(us_states, NAME %in% state_names)
  ne_states = cbind(ne_states, state_abbr)
}


head(by_state)
names(by_state)
melt(by_state, id.vars = c(8, 9, 10, 11))
melt(by_state, id.vars = c(8, 9, 10), measure.vars = )
by_state_melted = melt(by_state, measure.vars = c(8, 9, 10), id.vars = c("Species Name", 8, 9, 10))
by_state_melted = melt(by_state, measure.vars = c(1, 8, 9, 10), id.vars = c(8, 9, 10))
by_state_melted = melt(by_state, measure.vars = c(1), id.vars = c(8, 9, 10))
by_state_melted = melt(by_state, id.vars = c(1), measure.vars = c(8, 9, 10, 11), variable.name = "state_abbr")
by_state_melted
by_state_melted[, table(value)]
by_state_melted[, table(`Species Name`)]
by_state_melted[, unique(value)]


sp_names = unique(by_state_melted$`Species Name`)


setdiff(state_names_ne, state_names)

data.table(`Species Name` = sp_names, rep(setdiff(state_names_ne, state_names), each = length(sp_names)))

by_state_melted = 
  rbind(
    by_state_melted,
    data.table(
      `Species Name` = sp_names, 
      state_abbr = rep(setdiff(state_abbr_ne, state_abbr), each = length(sp_names)), value = ""))


by_state_melted[value == "", value := NA]


sp_name = "Ampelopsis brevipedunculata"
sp_name = "Acer platanoides"

dat1 = by_state_melted[`Species Name` == sp_name]

dat2 = merge(ne_states, by_state_melted[`Species Name` == sp_name], by = "state_abbr")
dat2
ggplot(dat2) + geom_sf(aes(fill = value)) + ggtitle(sp_name)











