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
                            date_range = c('2018-03-01','2018-08-01'),
                            metrics = "sessions",dimensions = "date")

# Make a simple plot
ggplot(sessions,aes(x=date,y=sessions))+geom_line()+labs(x="Date",y="Number of new users",title="")
