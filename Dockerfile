FROM rocker/shiny:latest

# Install system dependencies (needed for plotly, etc.)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libtiff5-dev \
    libjpeg-dev \
    libpng-dev \
    libglpk-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libgit2-dev

# Install required R packages
RUN R -e "install.packages(c('shiny', 'ggplot2', 'plotly', 'dplyr'), repos='https://cloud.r-project.org')"

# Copy Shiny app to image
COPY app.R /srv/shiny-server/

# Set correct permissions
RUN chown -R shiny:shiny /srv/shiny-server

# Expose the Shiny app port
EXPOSE 3838

# Run Shiny Server
CMD ["/usr/bin/shiny-server"]
