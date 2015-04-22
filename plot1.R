# plot1.R
# PM2.5 emissions evolution in the U.S. over the period 1999-2008.
# Course: Exploratory Data Analysis.
# Data Science Specialization.
# Second course project.
# Author: Pablo César Pérez González (pcesarperez@gmail.com)


# Constants
# 	`DATA_TABLE_PACKAGE`: Name of the `data.table` package, used in data transformation.
# 	`LATTICE_PACKAGE`: Name of the `lattice` package, used to plot the data.
# 	`EMISSIONS_DATA_VARIABLE`: Name of the variable wich holds the emissions data.
# 	`DATA_FILE`: PM2.5 emissions data filename.
# 	`LEGEND_FILE`: PM2.5 source names.
# 	`PNG_PLOT_FILE`: Filename of the PNG file which will hold the plot.
# 	`PNG_WIDTH`: Width of the PNG file.
# 	`PNG_HEIGHT`: Height of the PNG file.
# 	`PLOT_TITLE`: Title of the plot.
# 	`PLOT_TYPE`: Graph type (linear).
# 	`PLOT_X_LABEL`: Label of the X axis.
# 	`PLOT_Y_LABEL`: Label of the Y axis.
# 	`SCALE_FACTOR`: Scaling factor for the emissions data.
DATA_TABLE_PACKAGE <- "data.table"
LATTICE_PACKAGE <- "lattice"
EMISSIONS_DATA_VARIABLE <- "emissions_data"
DATA_FILE <- "summarySCC_PM25.rds"
LEGEND_FILE <- "Source_Classification_Code.rds"
PNG_PLOT_FILE <- "plot1.png"
PNG_WIDTH <- 512
PNG_HEIGHT <- 512
PLOT_TITLE <- expression ("PM"[2.5] ~ "emissions evolution")
PLOT_TYPE <- "l"
PLOT_X_LABEL <- "Year"
PLOT_Y_LABEL <- "Emissions (millions of tons)"
SCALE_FACTOR <- 1000000


# The package `data.table` is needed to perform the data aggregation.
if (!DATA_TABLE_PACKAGE %in% installed.packages ( )) {
	install.packages (DATA_TABLE_PACKAGE)
}
require (data.table)

# The package `lattice` is needed to perform the actual plotting.
if (!LATTICE_PACKAGE %in% installed.packages ( )) {
	install.packages (LATTICE_PACKAGE)
}
require (lattice)


# Reads the emissions data.
# The data is read only if it's not previously loaded in memory.
print ("Reading emissions data...")
if (!exists (EMISSIONS_DATA_VARIABLE)) {
	emissions_data <- readRDS (DATA_FILE)
}

# Creates a PNG file graphic device to hold the plot.
png (filename = PNG_PLOT_FILE, width = PNG_WIDTH, height = PNG_HEIGHT)

# We need to summarize the data, aggregating the emissions by year.
# The scale is stretched to millions of tons, just for readability.
print ("Creating aggregated data...")
emissions_by_year <- data.table (emissions_data) [, list (emissions = (sum (Emissions) / SCALE_FACTOR)), by = year]

print ("Creating the plot...")
print (with (emissions_by_year, {
	xyplot (
		emissions ~ year,
		type = PLOT_TYPE,
		xlab = PLOT_X_LABEL,
		ylab = PLOT_Y_LABEL,
		main = PLOT_TITLE
	)
}))

# Closes the PNG file graphic device.
dev.off ( )