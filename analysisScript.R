# This is the start of advertising impact project
# For Chicsterlocs

# Clear workspace
rm(list=ls())

# Load the required packages
library(CausalImpact)
library(googleAnalyticsR)
library(googleAuthR)
library(gridExtra)
library(ggplot2)

# Authenticate googleAnalytics - uncomment to authenticate
ga_auth()

# List accounts
account_list = ga_account_list()

# Pick a profile id with data to query
account_list[2,'viewId']

# Get the id of the account you want to extract data
ga_id = 169170564 # For Chicdreads:133523695  Chicsterlocs:169170564

# Get a list of all metrics and dimensions I can use.
meta <- google_analytics_meta()

# Get the data
sessions = google_analytics(ga_id,
                            date_range = c('2018-04-01','2018-10-30'),
                            metrics = c("sessions","Users","newUsers","bounces","sessionDuration"),dimensions = "date")

# Make a simple plot
gplot <- ggplot(sessions,aes(x=date,y=newUsers))+
  geom_line(color="blue")+
  #geom_line(aes(y=sessions),color="red")+
  #geom_line(aes(y=Users),color="black")+
  #geom_line(aes(y=sessionDuration),color="magenta")+
  labs(x="Date",y="Frequency",title="New users")+
  #scale_x_date(date_breaks = "1 month")+
  theme(axis.text.x = element_text(angle = 0,vjust = 0))

# Make another simple plot
gplot1 <- ggplot(sessions,aes(x=date,y=sessionDuration))+
  geom_line(color="blue")+labs(x="Date",y="Frequency",title="Session duration")

# Plot in a grid
grid.arrange(gplot,gplot1,nrow=2)

# Do the analysis

# Put the data together
data <- subset(sessions,select=c(date,newUsers,sessionDuration))

# Define pre and post periods to show the starting date of the intervention
pre.period <- as.Date(c("2018-04-01", "2018-07-01"))
post.period <- as.Date(c("2018-07-02", "2018-10-30"))

# Run the model
impact <- CausalImpact(data,pre.period,post.period,model.args = list(niter = 10000, nseasons = 1))

# Plot
plot(impact)

# Write report
summary(impact,"report")
