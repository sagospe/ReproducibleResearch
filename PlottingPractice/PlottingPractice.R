# Plotting practice

################################################################################
# 1. Make a plot that answers the question: what is the relationship between mean 
# covered charges (Average.Covered.Charges) and mean total
# payments (Average.Total.Payments) in New York?
#
# 2. Make a plot (possibly multi-panel) that answers the question: how does the 
# relationship between mean covered charges (Average.Covered.Charges) and mean 
# total payments (Average.Total.Payments) vary by medical condition 
# (DRG.Definition) and the state in which care was received (Provider.State)?
################################################################################


# Loading needed libraries
library(dplyr)
library(readr)


# loading data
payments <- read_csv(file = "./payments.csv", col_names = TRUE)

# selecting the useful variables
payments <- payments %>% select(DRG.Definition, Provider.State, Average.Total.Payments, Average.Covered.Charges)




################################################################################
## PLOT 1
################################################################################

# drawing plot 1, filtering the records by New York state
pdf(file = "./plot1.pdf")


payments_NY <- payments %>% filter(Provider.State == "NY")
plot(data = payments_NY, Average.Covered.Charges ~ Average.Total.Payments, 
     xlab = "Average Total Payments ($)", 
     ylab = "Average Coverage Charges ($)", 
     main = "Relationship between ATP ($) and ACC($) in NY",
     col = factor(DRG.Definition),
     pch = 20) 
legend("topright",
       legend = levels(as.factor(payments_NY$DRG.Definition)),
       cex = 0.5,
       fill = seq_along(levels(factor(payments_NY$DRG.Definition))))

# plotting the linear regression between both variables
fit <- lm(data = payments_NY, Average.Covered.Charges ~ Average.Total.Payments)
abline(fit, col = "red", lty = "dashed")


# saving the pdf file in home directory
dev.off()





################################################################################
## PLOT 2
################################################################################
pdf(file = "./plot2.pdf")

states <- levels(as.factor(payments$Provider.State))

payments <- mutate(payments, num.states = 1)

payments[payments$Provider.State == "CA",]$num.states <- 1 
payments[payments$Provider.State == "FL",]$num.states <- 2 
payments[payments$Provider.State == "IL",]$num.states <- 3 
payments[payments$Provider.State == "NY",]$num.states <- 4 
payments[payments$Provider.State == "PA",]$num.states <- 5 
payments[payments$Provider.State == "TX",]$num.states <- 6 

par(mfrow = c(2, 3))

for (i in 1:length(states)) {
        plot(data = payments[payments$num.states ==  i,], 
             Average.Covered.Charges ~ Average.Total.Payments, 
             xlab = "Average Total Payments ($)", 
             ylab = "Average Coverage Charges ($)", 
             main = paste("ATP ($) vs ACC($) in", states[i], sep =" "),
             col = factor(DRG.Definition),
             pch = 20,
             xlim = c(0,40000),
             ylim = c(0,200000))
        legend("topright",
               legend = levels(as.factor(payments$DRG.Definition)),
               cex = 0.2,
               fill = seq_along(levels(factor(payments$DRG.Definition))))
}

# saving the pdf file in home directory
dev.off()

