# This is the start of advertising impact project
# For Chicsterlocs

# Clear workspace
rm(list=ls())

# Load the required packages
require(CausalImpact)
require(googleAnalyticsR)
require(googleAuthR)
require(googleCloudStorageR)

# Dummy data
set.seed(1)
x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
y <- 1.2 * x1 + rnorm(100)
y[71:100] <- y[71:100] + 10
data <- cbind(y, x1)

# Plot the data
matplot(data,type = "l")

# Run the analysis
pre.period <- c(1, 70)
post.period <- c(71, 100)
impact <- CausalImpact(data, pre.period, post.period)
plot(impact)

# Generate prose report
summary(impact,"report")

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
                            date_range = c('2018-02-01','2018-10-30'),
                            metrics = c("sessions","Users","newUsers","bounces"),dimensions = "date")

# Make a simple plot
gplot <- ggplot(sessions,aes(x=date,y=newUsers))+
  geom_line(color="blue")+
  geom_line(aes(y=sessions),color="red")+
  geom_line(aes(y=Users),color="black")+
  labs(x="Date",y="Frequency")+scale_x_date(date_breaks = "1 month")+
  theme(axis.text.x = element_text(angle = -75,vjust = 0))

# Plot the figure
gplot